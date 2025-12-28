import SwiftUI

/// Glass morphism card modifier using `.thinMaterial` with subtle border and shadow.
/// Follows iOS design trends for modern, frosted glass appearance.
struct GlassCardModifier: ViewModifier {
    var cornerRadius: CGFloat
    var padding: CGFloat
    
    init(
        cornerRadius: CGFloat = AppTheme.CornerRadius.xl,
        padding: CGFloat = AppTheme.Spacing.xl
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
    }
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.thinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
            )
    }
}

/// Active glass card modifier with golden border for selected/active states.
struct ActiveGlassCardModifier: ViewModifier {
    var isActive: Bool
    var cornerRadius: CGFloat
    var padding: CGFloat
    
    init(
        isActive: Bool,
        cornerRadius: CGFloat = AppTheme.CornerRadius.xl,
        padding: CGFloat = AppTheme.Spacing.xl
    ) {
        self.isActive = isActive
        self.cornerRadius = cornerRadius
        self.padding = padding
    }
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.thinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .stroke(
                                isActive ? AppTheme.Colors.accent : .white.opacity(0.2),
                                lineWidth: isActive ? 2 : 1
                            )
                    )
                    .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
            )
            .animation(.easeInOut(duration: 0.2), value: isActive)
    }
}

// MARK: - View Extensions

extension View {
    /// Applies glass morphism styling to a view.
    /// - Parameters:
    ///   - cornerRadius: Corner radius for the glass card (default: AppTheme.CornerRadius.xl)
    ///   - padding: Internal padding for content (default: AppTheme.Spacing.xl)
    func glassCard(
        cornerRadius: CGFloat = AppTheme.CornerRadius.xl,
        padding: CGFloat = AppTheme.Spacing.xl
    ) -> some View {
        modifier(GlassCardModifier(cornerRadius: cornerRadius, padding: padding))
    }
    
    /// Applies glass morphism styling with golden border when active.
    /// - Parameters:
    ///   - isActive: Whether the card is in active/selected state
    ///   - cornerRadius: Corner radius for the glass card (default: AppTheme.CornerRadius.xl)
    ///   - padding: Internal padding for content (default: AppTheme.Spacing.xl)
    func activeGlassCard(
        isActive: Bool,
        cornerRadius: CGFloat = AppTheme.CornerRadius.xl,
        padding: CGFloat = AppTheme.Spacing.xl
    ) -> some View {
        modifier(ActiveGlassCardModifier(isActive: isActive, cornerRadius: cornerRadius, padding: padding))
    }
}

// MARK: - Previews

#Preview("Glass Cards") {
    VStack(spacing: AppTheme.Spacing.lg) {
        // Standard glass card
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("Standard Glass Card")
                .font(AppTheme.Typography.heading3)
                .foregroundColor(AppTheme.Colors.textPrimary)
            
            Text("This uses .thinMaterial with a subtle white border overlay.")
                .font(AppTheme.Typography.bodySmall)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
        .glassCard()
        
        // Active glass card
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("Active Glass Card")
                .font(AppTheme.Typography.heading3)
                .foregroundColor(AppTheme.Colors.textPrimary)
            
            Text("This shows the golden border when active.")
                .font(AppTheme.Typography.bodySmall)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
        .activeGlassCard(isActive: true)
        
        // Inactive glass card
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("Inactive Glass Card")
                .font(AppTheme.Typography.heading3)
                .foregroundColor(AppTheme.Colors.textPrimary)
            
            Text("Same styling as standard glass card when inactive.")
                .font(AppTheme.Typography.bodySmall)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
        .activeGlassCard(isActive: false)
    }
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("Dark Mode") {
    VStack(spacing: AppTheme.Spacing.lg) {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("Glass Card")
                .font(AppTheme.Typography.heading3)
                .foregroundColor(AppTheme.Colors.textPrimary)
            
            Text("Glass morphism works beautifully in dark mode too.")
                .font(AppTheme.Typography.bodySmall)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
        .glassCard()
        
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("Active Card")
                .font(AppTheme.Typography.heading3)
                .foregroundColor(AppTheme.Colors.textPrimary)
            
            Text("Golden border provides clear active state indication.")
                .font(AppTheme.Typography.bodySmall)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
        .activeGlassCard(isActive: true)
    }
    .padding()
    .background(AppTheme.Colors.background)
    .preferredColorScheme(.dark)
}

