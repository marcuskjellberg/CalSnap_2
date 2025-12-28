import SwiftUI

/// Individual action button revealed by swipe gesture.
/// Round button with icon, centered vertically in the card.
///
/// Visual specs:
/// - Size: 44pt diameter (round button)
/// - Icon: 20pt SF Symbol, semibold, white
/// - Spacing: 8pt between buttons
struct SwipeActionButton: View {
    let action: SwipeAction
    let cardHeight: CGFloat
    let revealProgress: CGFloat // 0 to 1, for animation
    
    // Button specs
    private let buttonSize: CGFloat = 44 // Diameter of round button
    private let iconSize: CGFloat = 20
    private let buttonSpacing: CGFloat = 8 // Spacing between buttons
    
    var body: some View {
        VStack {
            Spacer()
            
            Button {
                // Haptic feedback on tap
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                action.action()
            } label: {
                Image(systemName: action.icon)
                    .font(.system(size: iconSize, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: buttonSize, height: buttonSize)
                    .background(
                        Circle()
                            .fill(action.color)
                    )
            }
            .buttonStyle(.plain)
            .contentShape(Circle()) // Ensure entire button area is tappable
            .allowsHitTesting(revealProgress > 0.1) // Only allow taps when button is visible (threshold to avoid flickering)
            // Animate from zero size to full size based on reveal progress
            .scaleEffect(revealProgress)
            .opacity(revealProgress)
            .accessibilityLabel(accessibilityLabel)
            
            Spacer()
        }
        .frame(width: buttonSize)
    }
    
    private var accessibilityLabel: String {
        action.label ?? action.icon
    }
    
    /// Returns the width needed for this button including spacing
    var totalWidth: CGFloat {
        buttonSize + buttonSpacing
    }
}

// MARK: - Previews

#Preview("Action Buttons") {
    HStack(spacing: 8) {
        SwipeActionButton(
            action: .add { print("Add") },
            cardHeight: 100,
            revealProgress: 1.0
        )
        
        SwipeActionButton(
            action: .favorite(isFavorite: false) { print("Favorite") },
            cardHeight: 100,
            revealProgress: 1.0
        )
        
        SwipeActionButton(
            action: .delete { print("Delete") },
            cardHeight: 100,
            revealProgress: 1.0
        )
    }
    .frame(height: 100)
    .padding()
    .background(Color.gray.opacity(0.2))
}

#Preview("Reveal Progress") {
    VStack(spacing: 20) {
        Text("Progress: 0%")
        HStack(spacing: 8) {
            SwipeActionButton(
                action: .delete { },
                cardHeight: 80,
                revealProgress: 0.0
            )
        }
        .frame(height: 80)
        .padding()
        .background(Color.gray.opacity(0.2))
        
        Text("Progress: 50%")
        HStack(spacing: 8) {
            SwipeActionButton(
                action: .delete { },
                cardHeight: 80,
                revealProgress: 0.5
            )
        }
        .frame(height: 80)
        .padding()
        .background(Color.gray.opacity(0.2))
        
        Text("Progress: 100%")
        HStack(spacing: 8) {
            SwipeActionButton(
                action: .delete { },
                cardHeight: 80,
                revealProgress: 1.0
            )
        }
        .frame(height: 80)
        .padding()
        .background(Color.gray.opacity(0.2))
    }
    .padding()
}

#Preview("All Preset Actions") {
    VStack(spacing: 20) {
        HStack(spacing: 8) {
            SwipeActionButton(action: .add { }, cardHeight: 80, revealProgress: 1)
            SwipeActionButton(action: .edit { }, cardHeight: 80, revealProgress: 1)
        }
        .frame(height: 80)
        .padding()
        .background(Color.gray.opacity(0.2))
        
        HStack(spacing: 8) {
            SwipeActionButton(action: .favorite(isFavorite: false) { }, cardHeight: 80, revealProgress: 1)
            SwipeActionButton(action: .favorite(isFavorite: true) { }, cardHeight: 80, revealProgress: 1)
        }
        .frame(height: 80)
        .padding()
        .background(Color.gray.opacity(0.2))
        
        HStack(spacing: 8) {
            SwipeActionButton(action: .delete { }, cardHeight: 80, revealProgress: 1)
            SwipeActionButton(action: .share { }, cardHeight: 80, revealProgress: 1)
            SwipeActionButton(action: .archive { }, cardHeight: 80, revealProgress: 1)
        }
        .frame(height: 80)
        .padding()
        .background(Color.gray.opacity(0.2))
    }
    .padding()
}



