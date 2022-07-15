import PocketCastsServer
import UIKit

class CountryChooserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private static let cellId = "CountryCell"
    
    var regions = [DiscoverRegion]()
    var selectedRegion = ""
    
    @IBOutlet var countriesTable: UITableView! {
        didSet {
            countriesTable.applyInsetForMiniPlayer()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countriesTable.register(UINib(nibName: "CountryCell", bundle: nil), forCellReuseIdentifier: CountryChooserViewController.cellId)
        title = L10n.discoverSelectRegion
        
        countriesTable.reloadData()
    }
    
    // MARK: - UITableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        regions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryChooserViewController.cellId, for: indexPath) as! CountryCell
        let region = regions[indexPath.row]
        
        cell.populateFrom(region, selectedRegion: selectedRegion)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let region = regions[indexPath.row]
        selectedRegion = region.code
        Settings.setDiscoverRegion(region: selectedRegion)
        
        countriesTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        AppTheme.defaultStatusBarStyle()
    }
}