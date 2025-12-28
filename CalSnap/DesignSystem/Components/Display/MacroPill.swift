import SwiftUI

/// Compact pill displaying a macro value with icon and label.
/// Uses Asset-based colors for automatic Light/Dark mode support.
struct MacroPill: View {
    let label: String
    let value: String
    let color: Color
    var icon: String?
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.xxs) {
            if let icon = icon {
                Text(icon)
                    .font(.system(size: 14))
                    .accessibilityHidden(true)
            }
            
            Text(label)
                .font(AppTheme.Typography.captionTiny)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(value)
                .font(AppTheme.Typography.captionSmall)
                .fontWeight(.semibold)
                .foregroundColor(AppTheme.Colors.textPrimary)
        }
        .padding(.horizontal, AppTheme.Spacing.xs)
        .padding(.vertical, AppTheme.Spacing.xxs)
        .background(color.opacity(0.1))
        .cornerRadius(AppTheme.CornerRadius.sm)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label) \(value)")
    }
}

/// Row displaying macro progress with label, values, and progress bar.
/// Uses Asset-based colors for automatic Light/Dark mode support.
struct MacroRow: View {
    let label: String
    let current: Double
    let target: Double
    let color: Color
    let icon: String
    
    var progress: Double {
        guard target > 0 else { return 0 }
        return min(current / target, 1.0)
    }
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.xxs) {
            HStack {
                Text(icon)
                    .accessibilityHidden(true)
                Text(label)
                    .font(AppTheme.Typography.captionLarge)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                Spacer()
                Text("\(Int(current))/\(Int(target))g")
                    .font(AppTheme.Typography.captionLarge)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(label): \(Int(current)) of \(Int(target)) grams")
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.full)
                        .fill(AppTheme.Colors.progressBackground)
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.full)
                        .fill(color)
                        .frame(width: geometry.size.width * CGFloat(progress), height: 6)
                        .animation(.spring(duration: 0.5), value: progress)
                }
            }
            .frame(height: 6)
            .accessibilityHidden(true)
        }
    }
}

// MARK: - Previews

#Preview("Macro Pills") {
    HStack {
        MacroPill(label: "P", value: "24g", color: AppTheme.Colors.protein, icon: "💪")
        MacroPill(label: "C", value: "45g", color: AppTheme.Colors.carbs, icon: "🥦")
        MacroPill(label: "F", value: "12g", color: AppTheme.Colors.fat, icon: "💧")
    }
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("Macro Rows") {
    VStack(spacing: AppTheme.Spacing.md) {
        MacroRow(label: "PROTEIN", current: 85, target: 167, color: AppTheme.Colors.protein, icon: "💪")
        MacroRow(label: "CARBS", current: 120, target: 272, color: AppTheme.Colors.carbs, icon: "🥦")
        MacroRow(label: "FAT", current: 45, target: 61, color: AppTheme.Colors.fat, icon: "💧")
    }
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("Dark Mode") {
    VStack(spacing: AppTheme.Spacing.md) {
        HStack {
            MacroPill(label: "P", value: "24g", color: AppTheme.Colors.protein, icon: "💪")
            MacroPill(label: "C", value: "45g", color: AppTheme.Colors.carbs, icon: "🥦")
        }
        MacroRow(label: "PROTEIN", current: 85, target: 167, color: AppTheme.Colors.protein, icon: "💪")
    }
    .padding()
    .background(AppTheme.Colors.background)
    .preferredColorScheme(.dark)
}

#Preview("Large Dynamic Type") {
    VStack(spacing: AppTheme.Spacing.md) {
        HStack {
            MacroPill(label: "P", value: "24g", color: AppTheme.Colors.protein, icon: "💪")
            MacroPill(label: "C", value: "45g", color: AppTheme.Colors.carbs, icon: "🥦")
        }
        MacroRow(label: "PROTEIN", current: 85, target: 167, color: AppTheme.Colors.protein, icon: "💪")
    }
    .padding()
    .background(AppTheme.Colors.background)
    .environment(\.dynamicTypeSize, .accessibility2)
}
