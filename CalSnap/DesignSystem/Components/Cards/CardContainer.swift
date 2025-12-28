import SwiftUI

/// Reusable card container with configurable padding, corner radius, and shadow.
/// Uses Asset-based colors for automatic Light/Dark mode support.
struct CardContainer<Content: View>: View {
    let content: Content
    var padding: CGFloat
    var cornerRadius: CGFloat
    var showShadow: Bool
    var backgroundColor: Color
    
    init(
        padding: CGFloat = AppTheme.Spacing.md,
        cornerRadius: CGFloat = AppTheme.CornerRadius.lg,
        showShadow: Bool = true,
        backgroundColor: Color = AppTheme.Colors.cardBackground,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.showShadow = showShadow
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(
                color: showShadow ? AppShadow.card.color : .clear,
                radius: AppShadow.card.radius,
                x: AppShadow.card.x,
                y: AppShadow.card.y
            )
    }
}

// MARK: - Previews

#Preview("Simple Card") {
    VStack(spacing: AppTheme.Spacing.md) {
        CardContainer {
            Text("This is a simple card")
                .font(AppTheme.Typography.bodyMedium)
                .foregroundColor(AppTheme.Colors.textPrimary)
        }
        
        CardContainer(backgroundColor: AppTheme.Colors.secondaryBackground) {
            Text("Secondary background card")
                .font(AppTheme.Typography.bodyMedium)
                .foregroundColor(AppTheme.Colors.textPrimary)
        }
    }
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("Card with Title and Image") {
    CardContainer {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Image(systemName: "leaf.fill")
                .font(.largeTitle)
                .foregroundColor(AppTheme.Colors.primary)
            
            Text("Healthy Choice")
                .font(AppTheme.Typography.heading2)
                .foregroundColor(AppTheme.Colors.textPrimary)
            
            Text("This meal is high in protein and fiber, making it an excellent choice for your goals.")
                .font(AppTheme.Typography.bodySmall)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
    }
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("Dark Mode") {
    VStack(spacing: AppTheme.Spacing.md) {
        CardContainer {
            Text("Dark mode card")
                .font(AppTheme.Typography.bodyMedium)
                .foregroundColor(AppTheme.Colors.textPrimary)
        }
        
        CardContainer(showShadow: false) {
            Text("No shadow in dark mode")
                .font(AppTheme.Typography.bodyMedium)
                .foregroundColor(AppTheme.Colors.textPrimary)
        }
    }
    .padding()
    .background(AppTheme.Colors.background)
    .preferredColorScheme(.dark)
}
