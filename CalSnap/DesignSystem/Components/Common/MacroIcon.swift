//
//  MacroIcon.swift
//  CalSnap
//
//  Utility view for rendering macro icons consistently
//

import SwiftUI

/// Renders a macro icon with consistent styling
/// - Parameters:
///   - iconName: Name of the icon asset (e.g., "Calories", "Protein", "Carbs", "Fat")
///   - tint: Color to apply to the icon
///   - size: Icon size (defaults to sm)
struct MacroIcon: View {
    let iconName: String
    let tint: Color
    var size: CGFloat = AppTheme.IconSize.sm
    
    var body: some View {
        Image(iconName)
            .resizable()
            .renderingMode(.template)
            .foregroundColor(tint)
            .scaledToFit()
            .frame(width: size, height: size)
        
        
        
    }
}

// MARK: - Previews

#Preview("Macro Icons - Small") {
    HStack(spacing: AppTheme.Spacing.md) {
        MacroIcon(iconName: "Calories", tint: AppTheme.Colors.calories, size: AppTheme.IconSize.sm)
        MacroIcon(iconName: "Protein", tint: AppTheme.Colors.protein, size: AppTheme.IconSize.sm)
        MacroIcon(iconName: "Carbs", tint: AppTheme.Colors.carbs, size: AppTheme.IconSize.sm)
        MacroIcon(iconName: "Fat", tint: AppTheme.Colors.fat, size: AppTheme.IconSize.sm)
    }
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("Macro Icons - Large") {
    HStack(spacing: AppTheme.Spacing.lg) {
        MacroIcon(iconName: "Calories", tint: AppTheme.Colors.calories, size: AppTheme.IconSize.xl)
        MacroIcon(iconName: "Protein", tint: AppTheme.Colors.protein, size: AppTheme.IconSize.xl)
        MacroIcon(iconName: "Carbs", tint: AppTheme.Colors.carbs, size: AppTheme.IconSize.xl)
        MacroIcon(iconName: "Fat", tint: AppTheme.Colors.fat, size: AppTheme.IconSize.xl)
    }
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("Macro Icons - Dark Mode") {
    HStack(spacing: AppTheme.Spacing.md) {
        MacroIcon(iconName: "Calories", tint: AppTheme.Colors.calories)
        MacroIcon(iconName: "Protein", tint: AppTheme.Colors.protein)
        MacroIcon(iconName: "Carbs", tint: AppTheme.Colors.carbs)
        MacroIcon(iconName: "Fat", tint: AppTheme.Colors.fat)
    }
    .padding()
    .background(AppTheme.Colors.background)
    .preferredColorScheme(.dark)
}

