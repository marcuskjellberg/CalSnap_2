import Foundation

/// Food category classification
enum FoodCategory: String, Codable, CaseIterable {
    case vegetable = "vegetable"
    case fruit = "fruit"
    case grain = "grain"
    case protein = "protein"
    case dairy = "dairy"
    case fat = "fat"
    case beverage = "beverage"
    case snack = "snack"
    case condiment = "condiment"
    case sweet = "sweet"
    case processed = "processed"
    case other = "other"
    
    var displayName: String {
        switch self {
        case .vegetable: return "Vegetable"
        case .fruit: return "Fruit"
        case .grain: return "Grain"
        case .protein: return "Protein"
        case .dairy: return "Dairy"
        case .fat: return "Fat"
        case .beverage: return "Beverage"
        case .snack: return "Snack"
        case .condiment: return "Condiment"
        case .sweet: return "Sweet"
        case .processed: return "Processed"
        case .other: return "Other"
        }
    }
    
    var icon: String {
        switch self {
        case .vegetable: return "🥬"
        case .fruit: return "🍎"
        case .grain: return "🌾"
        case .protein: return "🥩"
        case .dairy: return "🥛"
        case .fat: return "🧈"
        case .beverage: return "🥤"
        case .snack: return "🍿"
        case .condiment: return "🧂"
        case .sweet: return "🍰"
        case .processed: return "🍔"
        case .other: return "🍽️"
        }
    }
}

