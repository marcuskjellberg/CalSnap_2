import SwiftUI

/// Color system following iOS best practices with 3-layer architecture.
///
/// **Layer 1 - Brand**: Marketing, hero elements (rarely used directly)
/// **Layer 2 - Domain**: App-specific meaning (macros, health levels)
/// **Layer 3 - UI Role**: Interface colors (text, backgrounds, status)
///
/// All colors are defined in Assets.xcassets with Light/Dark variants.
/// SwiftUI automatically selects the correct appearance.
struct ColorPalette {
    
    // MARK: - Layer 1: Brand Colors (rarely used directly)
    
    struct Brand {
        static let green = Color("BrandGreen")
        static let orange = Color("BrandOrange")
        static let red = Color("BrandRed")
        static let golden = Color(hex: "#FFD60A")  // Primary accent for active states
        static let goldenBorder = Color(hex: "#FFC107")  // Slightly darker golden for borders
    }
    
    // MARK: - Layer 2: Domain Colors (macros, health)
    
    struct Domain {
        // Nutrition macros
        static let calories = Color("Calories")
        static let protein = Color("Protein")
        static let carbs = Color("Carbs")
        static let fat = Color("Fat")
        static let fiber = Color("Fiber")
        
        // Health levels
        static let healthExcellent = Color("HealthExcellent")
        static let healthGood = Color("HealthGood")
        static let healthModerate = Color("HealthModerate")
        static let healthFair = Color("HealthFair")
        static let healthPoor = Color("HealthPoor")
    }
    
    // MARK: - Layer 3: UI Role Colors
    
    struct UI {
        // Text hierarchy
        static let textPrimary = Color("TextPrimary")
        static let textSecondary = Color("TextSecondary")
        static let textTertiary = Color("TextTertiary")
        
        // Backgrounds
        static let backgroundPrimary = Color("BackgroundPrimary")
        static let backgroundSecondary = Color("BackgroundSecondary")
        static let cardBackground = Color("CardBackground")
        
        // Borders & Dividers
        static let divider = Color("Divider")
        static let border = Color("Border")
        
        // Status colors (semantic)
        static let statusSuccess = Color("StatusSuccess")
        static let statusWarning = Color("StatusWarning")
        static let statusError = Color("StatusError")
    }
}

// MARK: - Convenience accessors (flat namespace for existing code compatibility)

extension ColorPalette {
    // Brand
    static let primaryGreen = Brand.green
    static let primaryOrange = Brand.orange
    static let primaryRed = Brand.red
    
    // Domain - Macros
    static let caloriesOrange = Domain.calories
    static let proteinPink = Domain.protein
    static let carbsGreen = Domain.carbs
    static let fatBlue = Domain.fat
    static let fiberPurple = Domain.fiber
    
    // Domain - Health
    static let healthExcellent = Domain.healthExcellent
    static let healthGood = Domain.healthGood
    static let healthModerate = Domain.healthModerate
    static let healthFair = Domain.healthFair
    static let healthPoor = Domain.healthPoor
    
    // UI Role
    static let backgroundPrimary = UI.backgroundPrimary
    static let backgroundSecondary = UI.backgroundSecondary
    static let backgroundTertiary = UI.backgroundSecondary
    static let textPrimary = UI.textPrimary
    static let textSecondary = UI.textSecondary
    static let textTertiary = UI.textTertiary
    static let border = UI.border
}
