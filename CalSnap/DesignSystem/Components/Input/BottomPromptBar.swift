import SwiftUI

/// Persistent bottom input bar for logging meals via text, photo, or voice.
/// Uses Asset-based colors for automatic Light/Dark mode support.
struct BottomPromptBar: View {
    @Binding var text: String
    var placeholder: String = "Add meal..."
    var languageCode: String = "🇸🇪"
    
    var onCameraTap: () -> Void
    var onFavoritesTap: () -> Void
    var onVoiceTap: () -> Void
    var onSendTap: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(AppTheme.Colors.divider)
            
            HStack(spacing: AppTheme.Spacing.sm) {
                // Action Buttons
                HStack(spacing: AppTheme.Spacing.xs) {
                    Button(action: onCameraTap) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 20))
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                    .accessibilityLabel("Take photo")
                    
                    Button(action: onFavoritesTap) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 20))
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                    .accessibilityLabel("Favorites")
                    
                    Button(action: onVoiceTap) {
                        Image(systemName: "mic.fill")
                            .font(.system(size: 20))
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                    .accessibilityLabel("Voice input")
                }
                
                // Text Input Field
                HStack {
                    TextField(placeholder, text: $text)
                        .font(AppTheme.Typography.bodyMedium)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                    
                    Text(languageCode)
                        .font(.system(size: 16))
                        .accessibilityLabel("Language")
                }
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.vertical, AppTheme.Spacing.xs)
                .background(AppTheme.Colors.secondaryBackground)
                .cornerRadius(AppTheme.CornerRadius.full)
                
                // Send Button
                if !text.isEmpty {
                    Button(action: onSendTap) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(AppTheme.Colors.primary)
                    }
                    .accessibilityLabel("Send")
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.vertical, AppTheme.Spacing.sm)
            .background(AppTheme.Colors.background)
        }
        .animation(.spring(), value: text.isEmpty)
    }
}

// MARK: - Previews

#Preview("Empty State") {
    VStack {
        Spacer()
        BottomPromptBar(
            text: .constant(""),
            onCameraTap: {},
            onFavoritesTap: {},
            onVoiceTap: {},
            onSendTap: {}
        )
    }
    .background(AppTheme.Colors.background)
}

#Preview("With Text") {
    VStack {
        Spacer()
        BottomPromptBar(
            text: .constant("Coffee with milk"),
            onCameraTap: {},
            onFavoritesTap: {},
            onVoiceTap: {},
            onSendTap: {}
        )
    }
    .background(AppTheme.Colors.background)
}

#Preview("Dark Mode") {
    VStack {
        Spacer()
        BottomPromptBar(
            text: .constant(""),
            onCameraTap: {},
            onFavoritesTap: {},
            onVoiceTap: {},
            onSendTap: {}
        )
    }
    .background(AppTheme.Colors.background)
    .preferredColorScheme(.dark)
}

#Preview("Large Dynamic Type") {
    VStack {
        Spacer()
        BottomPromptBar(
            text: .constant("Morning smoothie"),
            onCameraTap: {},
            onFavoritesTap: {},
            onVoiceTap: {},
            onSendTap: {}
        )
    }
    .background(AppTheme.Colors.background)
    .environment(\.dynamicTypeSize, .accessibility3)
}
