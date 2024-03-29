import Foundation
import SwiftUI

let darkBackgroundColor = Color(UIColor.tertiarySystemFill)
let lightBackgroundColor = Color(.clear)

struct LightBackgroundShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color(.sRGB, red: 0.5, green: 0.5, blue: 0.5, opacity: 0.08), radius: 50, x: 0, y: 40)
    }
}

extension View {
    func lightBackgroundShadow() -> some View {
        modifier(LightBackgroundShadow())
    }
}
