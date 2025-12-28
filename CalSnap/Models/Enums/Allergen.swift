import Foundation

/// Common food allergens
enum Allergen: String, Codable, CaseIterable {
    case nuts = "nuts"
    case peanuts = "peanuts"
    case dairy = "dairy"
    case eggs = "eggs"
    case soy = "soy"
    case wheat = "wheat"
    case gluten = "gluten"
    case fish = "fish"
    case shellfish = "shellfish"
    case sesame = "sesame"
    case sulfites = "sulfites"
    case mustard = "mustard"
    case celery = "celery"
    case lupin = "lupin"
    case molluscs = "molluscs"
    
    var displayName: String {
        switch self {
        case .nuts: return "Nuts"
        case .peanuts: return "Peanuts"
        case .dairy: return "Dairy"
        case .eggs: return "Eggs"
        case .soy: return "Soy"
        case .wheat: return "Wheat"
        case .gluten: return "Gluten"
        case .fish: return "Fish"
        case .shellfish: return "Shellfish"
        case .sesame: return "Sesame"
        case .sulfites: return "Sulfites"
        case .mustard: return "Mustard"
        case .celery: return "Celery"
        case .lupin: return "Lupin"
        case .molluscs: return "Molluscs"
        }
    }
    
    var icon: String {
        switch self {
        case .nuts: return "🥜"
        case .peanuts: return "🥜"
        case .dairy: return "🥛"
        case .eggs: return "🥚"
        case .soy: return "🫘"
        case .wheat, .gluten: return "🌾"
        case .fish: return "🐟"
        case .shellfish: return "🦐"
        case .sesame: return "🫘"
        case .sulfites: return "⚠️"
        case .mustard: return "🌭"
        case .celery: return "🥬"
        case .lupin: return "🫘"
        case .molluscs: return "🐚"
        }
    }
}

