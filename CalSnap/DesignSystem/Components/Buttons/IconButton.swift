import SwiftUI

/// Rounded icon button for secondary actions (camera, mic, settings).
/// Uses Asset-based colors for automatic Light/Dark mode support.
struct IconButton: View {
    let icon: String
    let size: CGFloat
    let action: () -> Void
    var color: Color = AppTheme.Colors.primary
    var isDisabled: Bool = false
    
    init(
        icon: String,
        size: CGFloat = 24,
        color: Color = AppTheme.Colors.primary,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.size = size
        self.color = color
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size))
                .foregroundColor(isDisabled ? AppTheme.Colors.textTertiary : color)
                .frame(width: size * 1.8, height: size * 1.8)
                .background(
                    Circle()
                        .fill(color.opacity(0.1))
                )
        }
        .disabled(isDisabled)
        .accessibilityLabel(icon.replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: "fill", with: ""))
    }
}

// MARK: - Previews

#Preview("Normal") {
    HStack(spacing: 20) {
        IconButton(icon: "camera.fill") { }
        IconButton(icon: "mic.fill", color: AppTheme.Colors.destructive) { }
        IconButton(icon: "gearshape.fill", color: AppTheme.Colors.textSecondary) { }
    }
    .padding()
}

#Preview("Disabled") {
    IconButton(icon: "camera.fill", isDisabled: true) { }
        .padding()
}

#Preview("Small & Large") {
    HStack(spacing: 20) {
        IconButton(icon: "plus", size: 16) { }
        IconButton(icon: "plus", size: 44) { }
    }
    .padding()
}

#Preview("Dark Mode") {
    HStack(spacing: 20) {
        IconButton(icon: "camera.fill") { }
        IconButton(icon: "mic.fill", color: AppTheme.Colors.destructive) { }
    }
    .padding()
    .background(AppTheme.Colors.background)
    .preferredColorScheme(.dark)
}
