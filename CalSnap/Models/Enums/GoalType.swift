import Foundation

/// User's fitness/nutrition goal type
enum GoalType: String, Codable, CaseIterable {
    case loseFat = "lose_fat"
    case maintain = "maintain"
    case gainMass = "gain_mass"
    
    var displayName: String {
        switch self {
        case .loseFat: return "Lose Weight"
        case .maintain: return "Maintain Weight"
        case .gainMass: return "Gain Muscle"
        }
    }
    
    var icon: String {
        switch self {
        case .loseFat: return "📉"
        case .maintain: return "➡️"
        case .gainMass: return "📈"
        }
    }
}

