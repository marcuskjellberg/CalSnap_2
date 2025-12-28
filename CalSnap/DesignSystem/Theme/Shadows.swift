import SwiftUI

/// Minimal shadow system following iOS design trends.
/// iOS prefers subtle elevation via background contrast over heavy shadows.
///
/// Guidelines:
/// - ✅ Use `card` shadow on floating cards in light mode
/// - ✅ Consider disabling shadows in dark mode (backgrounds provide contrast)
/// - ❌ Never stack multiple shadows
/// - ❌ Avoid shadows on inline list items
struct AppShadow {
    
    struct ShadowConfig {
        let color: Color
        let radius: CGFloat
        let x: CGFloat
        let y: CGFloat
    }
    
    /// Primary card shadow — use only on elevated cards
    static let card = ShadowConfig(
        color: Color.black.opacity(0.08),
        radius: 8,
        x: 0,
        y: 2
    )
    
    /// Subtle shadow for pressed states (rarely needed)
    static let subtle = ShadowConfig(
        color: Color.black.opacity(0.04),
        radius: 2,
        x: 0,
        y: 1
    )
}

// MARK: - View Extension for Easy Application

extension View {
    /// Applies the standard card shadow. Use sparingly.
    func cardShadow() -> some View {
        self.shadow(
            color: AppShadow.card.color,
            radius: AppShadow.card.radius,
            x: AppShadow.card.x,
            y: AppShadow.card.y
        )
    }
    
    /// Applies a subtle shadow for pressed states.
    func subtleShadow() -> some View {
        self.shadow(
            color: AppShadow.subtle.color,
            radius: AppShadow.subtle.radius,
            x: AppShadow.subtle.x,
            y: AppShadow.subtle.y
        )
    }
}
