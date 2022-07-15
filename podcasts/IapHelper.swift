import PocketCastsDataModel
import PocketCastsServer
import PocketCastsUtils
import StoreKit
import UIKit

class IapHelper: NSObject, SKProductsRequestDelegate {
    static let shared = IapHelper()
    
    let productIdentifiers = Set([Constants.IapProducts.monthly.rawValue, Constants.IapProducts.yearly.rawValue])
    
    var product: SKProduct?
    var productsArray = [SKProduct]()
    var requestedPurchase: String!
    
    fileprivate var productsRequest: SKProductsRequest?
    
    func requestProductInfo() {
        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
    }
    
    func getProductWithIdentifier(identifier: String) -> SKProduct! {
        guard productsArray.count > 0 else {
            requestProductInfo()
            return nil
        }
        
        for p in productsArray {
            if p.productIdentifier.caseInsensitiveCompare(identifier) == .orderedSame {
                return p
            }
        }
        return nil
    }
    
    public func getPriceForIdentifier(identifier: String) -> String {
        guard let product = getProductWithIdentifier(identifier: identifier) else { return "" }

        let numberFormatter = NumberFormatter()
        numberFormatter.formatterBehavior = .behavior10_4
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = product.priceLocale
        let formattedPrice = numberFormatter.string(from: product.price)
        return formattedPrice ?? ""
    }
    
    public func buyProduct(identifier: String) -> Bool {
        guard let product = getProductWithIdentifier(identifier: identifier), let _ = ServerSettings.syncingEmail() else {
            FileLog.shared.addMessage("IAPHelper Failed to initiate purchase of \(identifier)")
            return false
        }
        
        FileLog.shared.addMessage("IAPHelper Buying \(product.productIdentifier)")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
        
        return true
    }

    public func getPaymentFrequencyForIdentifier(identifier: String) -> String {
        if identifier == Constants.IapProducts.monthly.rawValue {
            return L10n.month
        }
        else if identifier == Constants.IapProducts.yearly.rawValue {
            return L10n.year
        }
        return ""
    }
    
    // MARK: SKProductReuqestDelelgate
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count > 0 {
            productsArray = response.products
            NotificationCenter.postOnMainThread(notification: ServerNotifications.iapProductsUpdated)
        }
        else {
            let invalid = response.invalidProductIdentifiers
            for i in invalid {
                FileLog.shared.addMessage("IAPHelper Invalid appstore identifier \(i)")
            }
            NotificationCenter.postOnMainThread(notification: ServerNotifications.iapProductsFailed)
        }
        clearRequestAndHandler()
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        FileLog.shared.addMessage("IAPHelper Failed to load list of products \(error.localizedDescription)")
        NotificationCenter.postOnMainThread(notification: ServerNotifications.iapProductsFailed)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
    }
}

extension IapHelper: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        FileLog.shared.addMessage("IAPHelper number of transactions in SKPayemntTransaction queue    \(transactions.count)")
        var hasNewPurchasedReceipt = false
        let lowercasedProductIdentifiers = productIdentifiers.map { $0.lowercased() }
        
        for transaction in transactions {
            let product = transaction.payment.productIdentifier
            let transactionDate = DateFormatHelper.sharedHelper.jsonFormat(transaction.transactionDate)
            FileLog.shared.addMessage("IAPHelper Processing transaction with id \(String(describing: transaction.transactionIdentifier)) \(transactionDate))")
            
            if lowercasedProductIdentifiers.contains(product.lowercased()) {
                switch transaction.transactionState {
                case .purchasing:
                    FileLog.shared.addMessage("IAPHelper Purchasing \(product)")
                case .purchased:
                    hasNewPurchasedReceipt = true
                    queue.finishTransaction(transaction)
                    FileLog.shared.addMessage("IAPHelper Purchase successful for \(product) ")
                case .failed:
                    let e = transaction.error! as NSError
                    FileLog.shared.addMessage("IAPHelper Purchase FAILED for \(product), code=\(e.code) msg= \(e.localizedDescription)/")
                    queue.finishTransaction(transaction)
                    
                    if e.code == 0 || e.code == 2 { // app store couldn't be connected or user cancelled
                        NotificationCenter.postOnMainThread(notification: ServerNotifications.iapPurchaseCancelled)
                    }
                    else { // report error to user
                        NotificationCenter.postOnMainThread(notification: ServerNotifications.iapPurchaseFailed)
                    }
                case .deferred:
                    FileLog.shared.addMessage("IAPHelper Purchase deferred for \(product)")
                    NotificationCenter.postOnMainThread(notification: ServerNotifications.iapPurchaseDeferred)
                case .restored:
                    queue.finishTransaction(transaction)
                default:
                    break
                }
            }
            else {
                FileLog.shared.addMessage("IAPHelper mark non-subscription transaction as finished")
                queue.finishTransaction(transaction)
            }
        }
        
        if hasNewPurchasedReceipt {
            if ServerSettings.iapUnverifiedPurchaseReceiptDate() == nil {
                ServerSettings.setIapUnverifiedPurchaseReceiptDate(Date())
            }
            ApiServerHandler.shared.sendPurchaseReceipt(completion: { success in
                if success {
                    FileLog.shared.addMessage("IAPHelper successfully validated receipt")
                }
                else {
                    FileLog.shared.addMessage("IAPHelper failed to validate receipt, but as the AppStore purchase was successful mark as Plus user on this device")
                }
            })
            NotificationCenter.postOnMainThread(notification: ServerNotifications.iapPurchaseCompleted)
        }
    }
}