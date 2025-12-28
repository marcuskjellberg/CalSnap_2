//
//  DayData.swift
//  CalSnap
//
//  Data model for a single day in the week calendar
//

import Foundation
import SwiftUI

/// Status indicator for a day's completion
enum DayStatus {
    case future          // —  (no data yet)
    case todayEmpty      // ○  (today, no meals logged)
    case todayPartial    // ◐  (today, partial completion)
    case complete        // ●  (day complete, past or present)
    
    var icon: String {
        switch self {
        case .future: return "—"
        case .todayEmpty: return "○"
        case .todayPartial: return "◐"
        case .complete: return "●"
        }
    }
    
    var color: Color {
        switch self {
        case .future: return AppTheme.Colors.textTertiary
        case .todayEmpty: return AppTheme.Colors.textSecondary
        case .todayPartial: return AppTheme.Colors.statusWarning
        case .complete: return AppTheme.Colors.statusSuccess
        }
    }
    
    /// Returns progress color based on percentage
    static func progressColor(for percentage: Int) -> Color {
        switch percentage {
        case 0..<80: return AppTheme.Colors.statusWarning  // Under target
        case 80...110: return AppTheme.Colors.statusSuccess // On track
        default: return AppTheme.Colors.statusError         // Over target
        }
    }
}

/// Data for a single day in the calendar
struct DayData: Identifiable {
    let id = UUID()
    let date: Date
    let dayNumber: Int
    let abbreviation: String
    let fullName: String
    let isToday: Bool
    let status: DayStatus
    let completionPercentage: Int
    let mealCount: Int
    
    /// Whether this day has any data (meals logged)
    var hasData: Bool {
        mealCount > 0
    }
    
    /// Progress color based on completion percentage
    var progressColor: Color {
        DayStatus.progressColor(for: completionPercentage)
    }
    
    /// Accessibility label for VoiceOver
    var accessibilityLabel: String {
        "\(fullName), \(dayNumber)"
    }
    
    /// Accessibility value describing the day's status
    var accessibilityValue: String {
        if hasData {
            return "\(mealCount) meals, \(completionPercentage)% of daily goal"
        } else {
            return "No meals logged"
        }
    }
}

/// Swedish day abbreviations
extension DayData {
    static let swedishAbbreviations = ["MÅN", "TIS", "ONS", "TOR", "FRE", "LÖR", "SÖN"]
    static let swedishFullNames = ["Måndag", "Tisdag", "Onsdag", "Torsdag", "Fredag", "Lördag", "Söndag"]
}

