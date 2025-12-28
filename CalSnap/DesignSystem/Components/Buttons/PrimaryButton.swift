import SwiftUI

/// Primary action button with loading and disabled states.
/// Uses Dynamic Type for accessibility and Asset-based colors for Light/Dark mode.
struct PrimaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false
    
    init(
        title: String,
        icon: String? = nil,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.xs) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    if let icon = icon {
                        Image(systemName: icon)
                    }
                    Text(title)
                        .font(AppTheme.Typography.bodyMedium)
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(isDisabled ? AppTheme.Colors.textTertiary : AppTheme.Colors.primary)
            .foregroundColor(.white)
            .cornerRadius(AppTheme.CornerRadius.md)
            .cardShadow()
        }
        .disabled(isDisabled || isLoading)
        .accessibilityLabel(title)
        .accessibilityAddTraits(isDisabled ? .isButton : [.isButton])
    }
}

// MARK: - Previews

#Preview("Normal") {
    VStack(spacing: 20) {
        PrimaryButton(title: "Add Meal", icon: "plus") {
            print("Button tapped")
        }
    }
    .padding()
}

#Preview("Disabled") {
    VStack(spacing: 20) {
        PrimaryButton(title: "Add Meal", icon: "plus", isDisabled: true) {
            print("Button tapped")
        }
    }
    .padding()
}

#Preview("Loading") {
    VStack(spacing: 20) {
        PrimaryButton(title: "Add Meal", icon: "plus", isLoading: true) {
            print("Button tapped")
        }
    }
    .padding()
}

#Preview("Long Content") {
    VStack(spacing: 20) {
        PrimaryButton(title: "This is a very long button title to test truncation", icon: "arrow.right.circle.fill") {
            print("Button tapped")
        }
    }
    .padding()
}

#Preview("Dark Mode") {
    VStack(spacing: 20) {
        PrimaryButton(title: "Add Meal", icon: "plus") {
            print("Button tapped")
        }
    }
    .padding()
    .background(AppTheme.Colors.background)
    .preferredColorScheme(.dark)
}

#Preview("Large Dynamic Type") {
    VStack(spacing: 20) {
        PrimaryButton(title: "Add Meal", icon: "plus") {
            print("Button tapped")
        }
    }
    .padding()
    .environment(\.dynamicTypeSize, .accessibility3)
}
