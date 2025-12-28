import SwiftUI

/// Unified design system namespace.
/// All UI code should reference AppTheme for colors, typography, spacing, and radii.
///
/// Architecture:
/// - Colors: 3-layer system (Brand → Domain → UI Role), Assets-based with Light/Dark
/// - Typography: Dynamic Type-based for accessibility
/// - Spacing: 6 core values, compose for larger gaps
/// - Shadows: Minimal, iOS-native approach
enum AppTheme {
    
    // MARK: - Colors (Assets-based, automatic Light/Dark)
    
    enum Colors {
        // Primary actions (Brand layer)
        static let primary = ColorPalette.Brand.green
        static let secondary = ColorPalette.Brand.orange
        static let destructive = ColorPalette.Brand.red
        
        // Nutrition macros (Domain layer)
        static let calories = ColorPalette.Domain.calories
        static let protein = ColorPalette.Domain.protein
        static let carbs = ColorPalette.Domain.carbs
        static let fat = ColorPalette.Domain.fat
        static let fiber = ColorPalette.Domain.fiber
        
        // Text hierarchy (UI Role layer)
        static let textPrimary = ColorPalette.UI.textPrimary
        static let textSecondary = ColorPalette.UI.textSecondary
        static let textTertiary = ColorPalette.UI.textTertiary
        
        // Backgrounds (UI Role layer)
        static let background = ColorPalette.UI.backgroundPrimary
        static let secondaryBackground = ColorPalette.UI.backgroundSecondary
        static let cardBackground = ColorPalette.UI.cardBackground
        static let imagePlaceholder = ColorPalette.UI.backgroundSecondary
        
        // Borders & Dividers
        static let border = ColorPalette.UI.border
        static let divider = ColorPalette.UI.divider
        static let progressBackground = ColorPalette.UI.backgroundSecondary
        
        // Status colors (semantic)
        static let statusSuccess = ColorPalette.UI.statusSuccess
        static let statusWarning = ColorPalette.UI.statusWarning
        static let statusError = ColorPalette.UI.statusError
    }
    
    // MARK: - Typography (Dynamic Type)
    
    enum Typography {
        // Display
        static let displayLarge = CalSnap.Typography.displayLarge
        static let displayMedium = CalSnap.Typography.displayMedium
        static let displaySmall = CalSnap.Typography.displaySmall
        
        // Headings
        static let heading1 = CalSnap.Typography.heading1
        static let heading2 = CalSnap.Typography.heading2
        static let heading3 = CalSnap.Typography.heading3
        
        // Body
        static let bodyLarge = CalSnap.Typography.bodyLarge
        static let bodyMedium = CalSnap.Typography.bodyMedium
        static let bodySmall = CalSnap.Typography.bodySmall
        
        // Captions
        static let captionLarge = CalSnap.Typography.captionLarge
        static let captionSmall = CalSnap.Typography.captionSmall
        static let captionTiny = CalSnap.Typography.captionTiny
        
        // Numbers (Rounded)
        static let numberLarge = CalSnap.Typography.numberLarge
        static let numberMedium = CalSnap.Typography.numberMedium
        static let numberSmall = CalSnap.Typography.numberSmall
    }
    
    // MARK: - Spacing (6 core values)
    
    enum Spacing {
        static let xxs = CalSnap.Spacing.xxs
        static let xs = CalSnap.Spacing.xs
        static let sm = CalSnap.Spacing.sm
        static let md = CalSnap.Spacing.md
        static let lg = CalSnap.Spacing.lg
        static let xl = CalSnap.Spacing.xl
    }
    
    // MARK: - Corner Radius
    
    enum CornerRadius {
        static let xs = CalSnap.CornerRadius.xs
        static let sm = CalSnap.CornerRadius.sm
        static let md = CalSnap.CornerRadius.md
        static let lg = CalSnap.CornerRadius.lg
        static let xl = CalSnap.CornerRadius.xl
        static let full = CalSnap.CornerRadius.full
    }
}
