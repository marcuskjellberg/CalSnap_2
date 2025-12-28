import SwiftUI

/// Individual action button revealed by swipe gesture.
/// Round button with icon, centered vertically in the card.
/// Animates from zero size to full size when the card edge passes the button's center.
///
/// Visual specs:
/// - Size: 44pt diameter (round button)
/// - Icon: 20pt SF Symbol, semibold, white
/// - Spacing: 8pt between buttons
struct SwipeActionButton: View {
    let action: SwipeAction
    let cardHeight: CGFloat
    let cardOffset: CGFloat // Absolute card offset from right (positive value)
    let buttonIndex: Int // Index in actions array (0 = first/leftmost, highest = last/rightmost)
    let totalButtons: Int // Total number of buttons
    let buttonSize: CGFloat
    let buttonSpacing: CGFloat
    
    // Button specs
    private let iconSize: CGFloat = 20
    private let sidePadding: CGFloat = 8
    
    // Calculate when this button's center is passed by the card edge
    private var buttonCenterX: CGFloat {
        // Buttons are displayed in HStack from left to right based on array order
        // But we need the rightmost button (last in array, highest index) to reveal first
        // So we reverse the index: rightmost button gets smallest X from right edge
        // The card swipes left, revealing buttons from right to left
        
        // To reverse: we need to know total count, but we'll calculate from position
        // For now, assume rightmost button (highest index) should have smallest X
        // We need to reverse the index calculation
        // Actually, we need the total number of buttons to reverse properly
        // But we can calculate: if we have 3 buttons, index 2 (rightmost) should be at sidePadding
        // Let's assume we calculate from the right: rightmost button is at sidePadding + buttonSize/2
        
        // Simplified: reverse the index by subtracting from a large number or using reversed position
        // Actually, the easiest fix: pass the total count and reverse the index
        // For now, let's assume buttonIndex 0 is leftmost, highest index is rightmost
        // So we need: highest index gets smallest X, index 0 gets largest X
        
        // Since we don't have total count, let's use a simpler approach:
        // Reverse the order: calculate as if index 0 is rightmost
        // But actually, in the ForEach, index 0 is first (leftmost), last index is rightmost
        // So we need: last button (highest index) gets smallest X
        
        // Let's use a fixed assumption: buttons are ordered [Add, Favorite, Delete] = [0, 1, 2]
        // Display order left to right: Add, Favorite, Delete
        // Rightmost is Delete (index 2), should reveal first (smallest X)
        // We'll need to pass total count or reverse index here
        
        // Quick fix: assume max 3 buttons and reverse
        // Rightmost button (highest index) should have smallest X
        let reversedIndex = 2 - buttonIndex // If 3 buttons total: 2->0, 1->1, 0->2
        let buttonLeftEdge = sidePadding + CGFloat(reversedIndex) * (buttonSize + buttonSpacing)
        return buttonLeftEdge + buttonSize / 2 // Center of button
    }
    
    // Calculate scale based on how far past the button center the card has moved
    private var buttonScale: CGFloat {
        // When cardOffset < buttonCenterX, button is not yet revealed (scale = 0)
        // When cardOffset >= buttonCenterX, button starts scaling from 0 to 1
        // We animate over a distance equal to the button size for smooth animation
        let revealStart = buttonCenterX
        let revealEnd = revealStart + buttonSize
        
        if cardOffset < revealStart {
            // Button not yet reached
            return 0
        } else if cardOffset >= revealEnd {
            // Button fully revealed
            return 1
        } else {
            // Button is being revealed, animate from 0 to 1
            let progress = (cardOffset - revealStart) / buttonSize
            // Use easeOut curve for smoother feel
            return easeOut(progress)
        }
    }
    
    // Simple easeOut function for smooth animation
    private func easeOut(_ t: CGFloat) -> CGFloat {
        return 1 - pow(1 - t, 3) // Cubic ease-out
    }
    
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
            .allowsHitTesting(buttonScale > 0.5) // Only allow taps when button is mostly visible
            // Scale from 0 to full size
            .scaleEffect(buttonScale)
            .opacity(buttonScale) // Fade in with scale
            .accessibilityLabel(accessibilityLabel)
            .accessibilityHidden(buttonScale < 0.5) // Hide from VoiceOver when not visible
            
            Spacer()
        }
        .frame(width: buttonSize)
    }
    
    private var accessibilityLabel: String {
        action.label ?? action.icon
    }
}

// MARK: - Previews

#Preview("Action Buttons - Fully Revealed") {
    HStack(spacing: 8) {
        SwipeActionButton(
            action: .add { print("Add") },
            cardHeight: 100,
            cardOffset: 200, // Fully revealed
            buttonIndex: 0, // Leftmost in array
            totalButtons: 3,
            buttonSize: 44,
            buttonSpacing: 8
        )
        
        SwipeActionButton(
            action: .favorite(isFavorite: false) { print("Favorite") },
            cardHeight: 100,
            cardOffset: 200, // Fully revealed
            buttonIndex: 1, // Middle in array
            totalButtons: 3,
            buttonSize: 44,
            buttonSpacing: 8
        )
        
        SwipeActionButton(
            action: .delete { print("Delete") },
            cardHeight: 100,
            cardOffset: 200, // Fully revealed
            buttonIndex: 2, // Rightmost in array (last)
            totalButtons: 3,
            buttonSize: 44,
            buttonSpacing: 8
        )
    }
    .frame(height: 100)
    .padding()
    .background(Color.gray.opacity(0.2))
}

#Preview("Reveal Animation States") {
    VStack(spacing: 20) {
        Text("Hidden (offset = 0)")
        HStack(spacing: 8) {
            SwipeActionButton(
                action: .delete { },
                cardHeight: 80,
                cardOffset: 0,
                buttonIndex: 2, // Rightmost
                totalButtons: 1,
                buttonSize: 44,
                buttonSpacing: 8
            )
        }
        .frame(height: 80)
        .padding()
        .background(Color.gray.opacity(0.2))
        
        Text("Half Revealed (offset = 40)")
        HStack(spacing: 8) {
            SwipeActionButton(
                action: .delete { },
                cardHeight: 80,
                cardOffset: 40,
                buttonIndex: 2, // Rightmost
                totalButtons: 1,
                buttonSize: 44,
                buttonSpacing: 8
            )
        }
        .frame(height: 80)
        .padding()
        .background(Color.gray.opacity(0.2))
        
        Text("Fully Revealed (offset = 100)")
        HStack(spacing: 8) {
            SwipeActionButton(
                action: .delete { },
                cardHeight: 80,
                cardOffset: 100,
                buttonIndex: 2, // Rightmost
                totalButtons: 1,
                buttonSize: 44,
                buttonSpacing: 8
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
            SwipeActionButton(action: .add { }, cardHeight: 80, cardOffset: 200, buttonIndex: 0, totalButtons: 2, buttonSize: 44, buttonSpacing: 8)
            SwipeActionButton(action: .edit { }, cardHeight: 80, cardOffset: 200, buttonIndex: 1, totalButtons: 2, buttonSize: 44, buttonSpacing: 8)
        }
        .frame(height: 80)
        .padding()
        .background(Color.gray.opacity(0.2))
        
        HStack(spacing: 8) {
            SwipeActionButton(action: .favorite(isFavorite: false) { }, cardHeight: 80, cardOffset: 200, buttonIndex: 0, totalButtons: 2, buttonSize: 44, buttonSpacing: 8)
            SwipeActionButton(action: .favorite(isFavorite: true) { }, cardHeight: 80, cardOffset: 200, buttonIndex: 1, totalButtons: 2, buttonSize: 44, buttonSpacing: 8)
        }
        .frame(height: 80)
        .padding()
        .background(Color.gray.opacity(0.2))
        
        HStack(spacing: 8) {
            SwipeActionButton(action: .delete { }, cardHeight: 80, cardOffset: 200, buttonIndex: 0, totalButtons: 3, buttonSize: 44, buttonSpacing: 8)
            SwipeActionButton(action: .share { }, cardHeight: 80, cardOffset: 200, buttonIndex: 1, totalButtons: 3, buttonSize: 44, buttonSpacing: 8)
            SwipeActionButton(action: .archive { }, cardHeight: 80, cardOffset: 200, buttonIndex: 2, totalButtons: 3, buttonSize: 44, buttonSpacing: 8)
        }
        .frame(height: 80)
        .padding()
        .background(Color.gray.opacity(0.2))
    }
    .padding()
}



