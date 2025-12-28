import SwiftUI

/// Individual action button revealed by swipe gesture.
/// Full height button with icon and optional label, used in swipe-to-reveal pattern.
///
/// Visual specs:
/// - Width: 70pt
/// - Height: Matches parent (full card height)
/// - Icon: 20pt SF Symbol, semibold, white
/// - Label: 11pt, medium weight, white (optional)
/// - Spacing: 4pt between icon and label
struct SwipeActionButton: View {
    let action: SwipeAction
    let height: CGFloat
    let revealProgress: CGFloat // 0 to 1, for animation
    
    // Button specs from design
    private let buttonWidth: CGFloat = 70
    private let iconSize: CGFloat = 20
    private let labelSize: CGFloat = 11
    private let iconLabelSpacing: CGFloat = 4
    
    var body: some View {
        Button {
            // Haptic feedback on tap
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            action.action()
        } label: {
            VStack(spacing: iconLabelSpacing) {
                Image(systemName: action.icon)
                    .font(.system(size: iconSize, weight: .semibold))
                    .foregroundColor(.white)
                
                if let label = action.label {
                    Text(label)
                        .font(.system(size: labelSize, weight: .medium))
                        .foregroundColor(.white)
                }
            }
            .frame(width: buttonWidth, height: height)
            .background(action.color)
            // Animate scale and opacity during reveal
            .scaleEffect(0.8 + (0.2 * revealProgress))
            .opacity(0.5 + (0.5 * revealProgress))
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle()) // Ensure entire button area is tappable
        .allowsHitTesting(true) // Explicitly allow hit testing
        .accessibilityLabel(accessibilityLabel)
    }
    
    private var accessibilityLabel: String {
        action.label ?? action.icon
    }
}

// MARK: - Previews

#Preview("Action Buttons") {
    HStack(spacing: 0) {
        SwipeActionButton(
            action: .add { print("Add") },
            height: 100,
            revealProgress: 1.0
        )
        
        SwipeActionButton(
            action: .favorite(isFavorite: false) { print("Favorite") },
            height: 100,
            revealProgress: 1.0
        )
        
        SwipeActionButton(
            action: .delete { print("Delete") },
            height: 100,
            revealProgress: 1.0
        )
    }
    .frame(height: 100)
}

#Preview("Reveal Progress") {
    VStack(spacing: 20) {
        Text("Progress: 0%")
        HStack(spacing: 0) {
            SwipeActionButton(
                action: .delete { },
                height: 80,
                revealProgress: 0.0
            )
        }
        .frame(height: 80)
        
        Text("Progress: 50%")
        HStack(spacing: 0) {
            SwipeActionButton(
                action: .delete { },
                height: 80,
                revealProgress: 0.5
            )
        }
        .frame(height: 80)
        
        Text("Progress: 100%")
        HStack(spacing: 0) {
            SwipeActionButton(
                action: .delete { },
                height: 80,
                revealProgress: 1.0
            )
        }
        .frame(height: 80)
    }
    .padding()
}

#Preview("All Preset Actions") {
    VStack(spacing: 20) {
        HStack(spacing: 0) {
            SwipeActionButton(action: .add { }, height: 80, revealProgress: 1)
            SwipeActionButton(action: .edit { }, height: 80, revealProgress: 1)
        }
        
        HStack(spacing: 0) {
            SwipeActionButton(action: .favorite(isFavorite: false) { }, height: 80, revealProgress: 1)
            SwipeActionButton(action: .favorite(isFavorite: true) { }, height: 80, revealProgress: 1)
        }
        
        HStack(spacing: 0) {
            SwipeActionButton(action: .delete { }, height: 80, revealProgress: 1)
            SwipeActionButton(action: .share { }, height: 80, revealProgress: 1)
            SwipeActionButton(action: .archive { }, height: 80, revealProgress: 1)
        }
    }
    .padding()
    .background(Color.gray.opacity(0.2))
}



