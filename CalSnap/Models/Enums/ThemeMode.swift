import Foundation

/// App theme mode preference
enum ThemeMode: String, Codable, CaseIterable {
    case auto = "auto"
    case light = "light"
    case dark = "dark"
    
    var displayName: String {
        switch self {
        case .auto: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}

