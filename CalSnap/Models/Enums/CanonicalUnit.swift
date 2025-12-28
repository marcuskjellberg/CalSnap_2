import Foundation

/// Canonical units for food quantities
enum CanonicalUnit: String, Codable, CaseIterable {
    case grams = "g"
    case milliliters = "ml"
    case count = "count"
    
    var displayName: String {
        switch self {
        case .grams: return "grams"
        case .milliliters: return "ml"
        case .count: return "count"
        }
    }
    
    var abbreviation: String {
        rawValue
    }
}

