import SwiftUI

/// Represents the health assessment level of a meal
enum HealthLevel: String, Codable, CaseIterable {
    case excellent = "excellent"
    case good = "good"
    case moderate = "moderate"
    case fair = "fair"
    case poor = "poor"
    case unknown = "unknown"
    
    var displayName: String {
        switch self {
        case .excellent: return "Excellent"
        case .good: return "Good"
        case .moderate: return "Moderate"
        case .fair: return "Fair"
        case .poor: return "Poor"
        case .unknown: return "Unknown"
        }
    }
    
    var color: Color {
        switch self {
        case .excellent: return Color("HealthExcellent")
        case .good: return Color("HealthGood")
        case .moderate: return Color("HealthModerate")
        case .fair: return Color("HealthFair")
        case .poor: return Color("HealthPoor")
        case .unknown: return Color("TextTertiary")
        }
    }
    
    var icon: String {
        switch self {
        case .excellent: return "🟢"
        case .good: return "🟢"
        case .moderate: return "🟡"
        case .fair: return "🟠"
        case .poor: return "🔴"
        case .unknown: return "⚪"
        }
    }
}

