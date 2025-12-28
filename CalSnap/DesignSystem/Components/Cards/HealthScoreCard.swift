import SwiftUI

/// Card displaying AI-generated health insights and allergen warnings.
/// Uses Asset-based colors for automatic Light/Dark mode support.
struct HealthScoreCard: View {
    let title: String
    let description: String
    let statusColor: Color
    var allergenWarning: String?
    
    var body: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                // Header with icon
                HStack(spacing: AppTheme.Spacing.xs) {
                    Text("🔍")
                        .accessibilityHidden(true)
                    Text(title)
                        .font(AppTheme.Typography.heading3)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                }
                
                // Description
                Text(description)
                    .font(AppTheme.Typography.bodySmall)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                    .lineSpacing(4)
                
                // Allergen warning (if present)
                if let warning = allergenWarning {
                    HStack(spacing: AppTheme.Spacing.xs) {
                        Text("⚠️")
                            .accessibilityHidden(true)
                        Text(warning)
                            .font(AppTheme.Typography.captionLarge)
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.Colors.statusError)
                    }
                    .padding(.vertical, AppTheme.Spacing.xs)
                    .padding(.horizontal, AppTheme.Spacing.sm)
                    .background(AppTheme.Colors.statusError.opacity(0.1))
                    .cornerRadius(AppTheme.CornerRadius.sm)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Allergen warning: \(warning)")
                }
                
                // Disclaimer
                Text("AI estimate. Not medical advice.")
                    .font(AppTheme.Typography.captionTiny)
                    .foregroundColor(AppTheme.Colors.textTertiary)
                    .padding(.top, AppTheme.Spacing.xxs)
            }
        }
        .accessibilityElement(children: .contain)
    }
}

// MARK: - Previews

#Preview("Healthy Insight") {
    HealthScoreCard(
        title: "INSIGHTS",
        description: "This meal is rich in lean protein and healthy fats. The avocado provides good monounsaturated fats which are heart-healthy.",
        statusColor: AppTheme.Colors.statusSuccess
    )
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("Allergen Warning") {
    HealthScoreCard(
        title: "INSIGHTS",
        description: "Sugar-free candy is better for blood sugar, but keep in mind that sweeteners can have a laxative effect in larger quantities.",
        statusColor: AppTheme.Colors.statusWarning,
        allergenWarning: "NUTS (ALMOND)"
    )
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("Dark Mode") {
    HealthScoreCard(
        title: "INSIGHTS",
        description: "High protein intake detected. Make sure to drink enough water.",
        statusColor: AppTheme.Colors.statusSuccess
    )
    .padding()
    .background(AppTheme.Colors.background)
    .preferredColorScheme(.dark)
}

#Preview("Large Dynamic Type") {
    HealthScoreCard(
        title: "INSIGHTS",
        description: "This meal is balanced and nutritious.",
        statusColor: AppTheme.Colors.statusSuccess,
        allergenWarning: "DAIRY"
    )
    .padding()
    .background(AppTheme.Colors.background)
    .environment(\.dynamicTypeSize, .accessibility2)
}
