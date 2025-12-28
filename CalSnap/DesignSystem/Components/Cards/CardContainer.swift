import SwiftUI

/// Reusable card container supporting both traditional solid and glass morphism styles.
/// Uses Asset-based colors for automatic Light/Dark mode support.
struct CardContainer<Content: View>: View {
    let content: Content
    var padding: CGFloat
    var cornerRadius: CGFloat
    var showShadow: Bool
    var backgroundColor: Color
    var style: CardStyle
    var isActive: Bool
    
    enum CardStyle {
        case solid      // Traditional solid background
        case glass      // Glass morphism with .thinMaterial
    }
    
    init(
        padding: CGFloat = AppTheme.Spacing.md,
        cornerRadius: CGFloat = AppTheme.CornerRadius.lg,
        showShadow: Bool = true,
        backgroundColor: Color = AppTheme.Colors.cardBackground,
        style: CardStyle = .glass,  // Default to glass morphism
        isActive: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.showShadow = showShadow
        self.backgroundColor = backgroundColor
        self.style = style
        self.isActive = isActive
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(backgroundView)
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .solid:
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(backgroundColor)
                .shadow(
                    color: showShadow ? AppShadow.card.color : .clear,
                    radius: AppShadow.card.radius,
                    x: AppShadow.card.x,
                    y: AppShadow.card.y
                )
        case .glass:
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(.thinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .stroke(
                            isActive ? AppTheme.Colors.accent : .black.opacity(0.2),
                            lineWidth: isActive ? 2 : 1
                        )
                )
                .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
        }
    }
}

// MARK: - Previews

#Preview("Glass Cards (Default)") {
    VStack(spacing: AppTheme.Spacing.md) {
        CardContainer {
            Text("Glass morphism card (default style)")
                .font(AppTheme.Typography.bodyMedium)
                .foregroundColor(AppTheme.Colors.textPrimary)
        }
        
        CardContainer(isActive: true) {
            Text("Active glass card with golden border")
                .font(AppTheme.Typography.bodyMedium)
                .foregroundColor(AppTheme.Colors.textPrimary)
        }
    }
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("Solid Cards") {
    VStack(spacing: AppTheme.Spacing.md) {
        CardContainer(style: .solid) {
            Text("Solid background card")
                .font(AppTheme.Typography.bodyMedium)
                .foregroundColor(AppTheme.Colors.textPrimary)
        }
        
        CardContainer(backgroundColor: AppTheme.Colors.secondaryBackground, style: .solid) {
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
            Text("Glass card in dark mode")
                .font(AppTheme.Typography.bodyMedium)
                .foregroundColor(AppTheme.Colors.textPrimary)
        }
        
        CardContainer(isActive: true) {
            Text("Active glass card with golden border")
                .font(AppTheme.Typography.bodyMedium)
                .foregroundColor(AppTheme.Colors.textPrimary)
        }
        
        CardContainer(style: .solid) {
            Text("Solid card for comparison")
                .font(AppTheme.Typography.bodyMedium)
                .foregroundColor(AppTheme.Colors.textPrimary)
        }
    }
    .padding()
    .background(AppTheme.Colors.background)
    .preferredColorScheme(.dark)
}
