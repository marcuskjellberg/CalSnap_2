import Foundation

/// Dietary preference and restriction tags
enum DietaryTag: String, Codable, CaseIterable {
    case vegetarian = "vegetarian"
    case vegan = "vegan"
    case pescatarian = "pescatarian"
    case glutenFree = "gluten_free"
    case dairyFree = "dairy_free"
    case keto = "keto"
    case paleo = "paleo"
    case lowCarb = "low_carb"
    case highProtein = "high_protein"
    case lowFat = "low_fat"
    case lowSodium = "low_sodium"
    case sugarFree = "sugar_free"
    case organic = "organic"
    case rawFood = "raw_food"
    
    var displayName: String {
        switch self {
        case .vegetarian: return "Vegetarian"
        case .vegan: return "Vegan"
        case .pescatarian: return "Pescatarian"
        case .glutenFree: return "Gluten-Free"
        case .dairyFree: return "Dairy-Free"
        case .keto: return "Keto"
        case .paleo: return "Paleo"
        case .lowCarb: return "Low Carb"
        case .highProtein: return "High Protein"
        case .lowFat: return "Low Fat"
        case .lowSodium: return "Low Sodium"
        case .sugarFree: return "Sugar-Free"
        case .organic: return "Organic"
        case .rawFood: return "Raw Food"
        }
    }
    
    var icon: String {
        switch self {
        case .vegetarian: return "🥗"
        case .vegan: return "🌱"
        case .pescatarian: return "🐟"
        case .glutenFree: return "🚫🌾"
        case .dairyFree: return "🚫🥛"
        case .keto: return "🥓"
        case .paleo: return "🍖"
        case .lowCarb: return "📉"
        case .highProtein: return "💪"
        case .lowFat: return "📉"
        case .lowSodium: return "🧂"
        case .sugarFree: return "🚫🍬"
        case .organic: return "🌿"
        case .rawFood: return "🥕"
        }
    }
}

