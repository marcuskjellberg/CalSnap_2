import SwiftUI

/// Represents the AI's confidence in its analysis
enum ConfidenceLevel: String, Codable, CaseIterable {
    case high = "high"
    case medium = "medium"
    case low = "low"
    
    var displayName: String {
        switch self {
        case .high: return "High Confidence"
        case .medium: return "Medium Confidence"
        case .low: return "Low Confidence"
        }
    }
    
    var icon: String {
        switch self {
        case .high: return "checkmark.circle.fill"
        case .medium: return "exclamationmark.circle.fill"
        case .low: return "questionmark.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .high: return Color("StatusSuccess")
        case .medium: return Color("StatusWarning")
        case .low: return Color("StatusError")
        }
    }
}

