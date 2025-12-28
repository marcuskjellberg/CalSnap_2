import SwiftUI

/// A generic swipeable card wrapper that adds iOS Mail-style swipe actions to any card content.
///
/// Swipe left to reveal action buttons on the right side. Supports 1-3 actions with
/// configurable full-swipe behavior for the last action (typically delete).
///
/// ## Usage
/// ```swift
/// SwipeableCard(
///     actions: [
///         .add { logMeal(meal) },
///         .favorite(isFavorite: meal.isFavorite) { toggleFavorite(meal) },
///         .delete { deleteMeal(meal) }
///     ]
/// ) {
///     MealCard(title: meal.title, ...)
/// }
/// ```
///
/// ## Thresholds
/// - Snap back: Release before 80pt
/// - Snap reveal: Release after 80pt → reveals all actions
/// - Full swipe: Release after 250pt → triggers last action (if enabled)
///
/// ## Haptics
/// - Light impact at 80pt threshold
/// - Heavy impact at 250pt (full swipe threshold)
/// - Medium impact on button tap
/// - Success notification on action completion
struct SwipeableCard<Content: View>: View {
    
    // MARK: - Properties
    
    let actions: [SwipeAction]
    let cardHeight: CGFloat
    let enableFullSwipe: Bool
    let content: Content
    
    // MARK: - State
    
    @State private var dragOffset: CGFloat = 0
    @State private var isRevealed: Bool = false
    @GestureState private var isDragging: Bool = false
    @State private var hasTriggeredRevealHaptic: Bool = false
    @State private var hasTriggeredFullSwipeHaptic: Bool = false
    
    // MARK: - Constants
    
    private let revealThreshold: CGFloat = -80
    private let fullSwipeThreshold: CGFloat = -250
    private let minimumDragDistance: CGFloat = 20
    
    // MARK: - Computed
    
    private var totalRevealWidth: CGFloat {
        guard !actions.isEmpty else { return 0 }
        // Each button is 44pt + 8pt spacing (last button has no trailing spacing)
        return CGFloat(actions.count) * 44 + CGFloat(actions.count - 1) * 8 + 16 // 16pt padding on each side
    }
    
    private var currentOffset: CGFloat {
        if isRevealed {
            return -totalRevealWidth + dragOffset
        } else {
            return dragOffset
        }
    }
    
    private var revealProgress: CGFloat {
        guard totalRevealWidth > 0 else { return 0 }
        let progress = abs(currentOffset) / totalRevealWidth
        return min(1, max(0, progress))
    }
    
    // MARK: - Init
    
    /// Creates a swipeable card wrapper.
    /// - Parameters:
    ///   - actions: Array of swipe actions to reveal (max 3 recommended)
    ///   - cardHeight: Height of the card content (default: 100pt)
    ///   - enableFullSwipe: Whether full swipe triggers the last action (default: false)
    ///   - content: The card content to wrap
    init(
        actions: [SwipeAction],
        cardHeight: CGFloat = 100,
        enableFullSwipe: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.actions = actions
        self.cardHeight = cardHeight
        self.enableFullSwipe = enableFullSwipe
        self.content = content()
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .trailing) {
            // Action buttons (behind the card, but tappable when revealed)
            if !actions.isEmpty {
                actionButtonsRow
                    .zIndex(10) // Highest zIndex so buttons are tappable when revealed
            }
            
            // Card content (on top, draggable)
            content
                .offset(x: currentOffset)
                .shadow(
                    color: isDragging ? .black.opacity(0.12) : .black.opacity(0.08),
                    radius: isDragging ? 16 : 12,
                    y: isDragging ? 6 : 4
                )
                .contentShape(Rectangle())
                .highPriorityGesture(actions.isEmpty ? nil : dragGesture)
                .zIndex(isRevealed ? 1 : 5) // Lower zIndex when revealed so buttons can be tapped
                .allowsHitTesting(true)
                .overlay(
                    // Invisible overlay that captures taps when revealed and has high priority
                    // This overlay sits on top and intercepts taps to collapse the card
                    Group {
                        if isRevealed {
                            Color.clear
                                .contentShape(Rectangle())
                                .highPriorityGesture(
                                    TapGesture()
                                        .onEnded { _ in
                                            dismissActions()
                                        }
                                )
                        }
                    }
                )
            
            // Background tap area - only catches taps outside buttons and card
            // We don't need this as the card's tap gesture handles dismiss
        }
        .frame(height: cardHeight)
        .clipped()
        .onChange(of: isDragging) { _, newValue in
            if !newValue {
                hasTriggeredRevealHaptic = false
                hasTriggeredFullSwipeHaptic = false
            }
        }
        // Add accessibility actions for VoiceOver users
        .accessibilityElement(children: .contain)
        .accessibilityActions {
            ForEach(actions) { action in
                Button(action.label ?? action.icon) {
                    action.action()
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var actionButtonsRow: some View {
        HStack(spacing: 8) {
            // Leading padding
            Spacer()
                .frame(width: 8)
            
            ForEach(Array(actions.enumerated()), id: \.element.id) { index, action in
                SwipeActionButton(
                    action: SwipeAction(
                        icon: action.icon,
                        label: action.label,
                        color: action.color,
                        action: {
                            handleAction(action)
                        }
                    ),
                    cardHeight: cardHeight,
                    revealProgress: buttonRevealProgress(for: index)
                )
            }
            
            // Trailing padding
            Spacer()
            //    .frame(width: 8)
                .frame(width: 1)
        }
        .frame(width: totalRevealWidth, alignment: .trailing)
        .allowsHitTesting(isRevealed && !isDragging) // Only allow taps when revealed and not dragging
    }
    
    /// Calculates the reveal progress for a specific button based on when the card passes its center
    /// - Parameter buttonIndex: Index of the button in the actions array
    /// - Returns: Progress from 0.0 to 1.0, where 0.0 means button center hasn't been passed yet
    /// 
    /// Note: Buttons in the array are rendered left-to-right in the HStack, but we want the
    /// rightmost button (last in array) to reveal first. So we reverse the calculation.
    private func buttonRevealProgress(for buttonIndex: Int) -> CGFloat {
        guard buttonIndex < actions.count else { return 0 }
        
        let buttonWidth: CGFloat = 44
        let buttonSpacing: CGFloat = 8
        let sidePadding: CGFloat = 8
        
        // Reverse the index so the last button (rightmost) reveals first
        // For 3 buttons: [0=Add, 1=Favorite, 2=Delete]
        // We want Delete (index 2) to reveal first, so reverseIndex = 0
        let reverseIndex = actions.count - 1 - buttonIndex
        
        // Calculate the center position of this button from the trailing (right) edge
        // Rightmost button (reverseIndex 0) starts closest to the edge
        var centerFromTrailing: CGFloat = sidePadding + buttonWidth / 2
        
        // Add spacing for buttons that come before this one (to the right of it)
        for _ in 0..<reverseIndex {
            centerFromTrailing += buttonWidth + buttonSpacing
        }
        
        // The absolute offset of the card (how far left it has moved, so negative becomes positive)
        let absoluteOffset = abs(currentOffset)
        
        // Calculate progress: 0 when card hasn't reached center, 1 when fully passed
        // Use a smooth interpolation from 0 to 1 over the button width
        let progressStart = centerFromTrailing - buttonWidth / 2
        let progressEnd = centerFromTrailing + buttonWidth / 2
        
        if absoluteOffset < progressStart {
            return 0
        } else if absoluteOffset > progressEnd {
            return 1
        } else {
            // Linear interpolation between start and end
            let normalizedProgress = (absoluteOffset - progressStart) / (progressEnd - progressStart)
            return normalizedProgress
        }
    }
    
    // MARK: - Gesture
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: minimumDragDistance)
            .updating($isDragging) { value, state, _ in
                // Only set dragging for clearly horizontal swipes
                let horizontal = abs(value.translation.width)
                let vertical = abs(value.translation.height)
                if horizontal > vertical * 1.5 && horizontal > 15 {
                    state = true
                }
            }
            .onChanged { value in
                // Only process clearly horizontal swipes
                let horizontal = abs(value.translation.width)
                let vertical = abs(value.translation.height)
                
                guard horizontal > vertical * 1.5 && horizontal > 15 else {
                    return
                }
                
                let translation = value.translation.width
                
                if isRevealed {
                    // When revealed, allow dragging in both directions
                    let newOffset = translation
                    // Constrain: can go right (positive) to close, or left (negative) a bit more
                    dragOffset = max(-50, min(totalRevealWidth, newOffset))
                } else {
                    // When resting, only allow left swipe
                    let constrained = min(0, max(-totalRevealWidth - 50, translation))
                    dragOffset = constrained
                }
                
                // Haptic at reveal threshold
                let absoluteOffset = abs(currentOffset)
                if absoluteOffset > abs(revealThreshold) && !hasTriggeredRevealHaptic {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    hasTriggeredRevealHaptic = true
                }
                
                // Haptic at full swipe threshold
                if enableFullSwipe && absoluteOffset > abs(fullSwipeThreshold) && !hasTriggeredFullSwipeHaptic {
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    hasTriggeredFullSwipeHaptic = true
                }
            }
            .onEnded { value in
                let horizontal = abs(value.translation.width)
                let vertical = abs(value.translation.height)
                
                // If not a horizontal swipe, snap back
                guard horizontal > vertical * 1.5 && horizontal > 15 else {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                        dragOffset = 0
                    }
                    return
                }
                
                let finalOffset = currentOffset
                
                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                    // Check for full swipe delete
                    if enableFullSwipe && finalOffset < fullSwipeThreshold {
                        if let lastAction = actions.last {
                            handleAction(lastAction)
                        }
                        return
                    }
                    
                    // Check if should reveal or dismiss
                    if isRevealed {
                        // If dragged right past half, dismiss
                        if dragOffset > totalRevealWidth / 2 {
                            dismissActions()
                        } else {
                            // Stay revealed
                            dragOffset = 0
                        }
                    } else {
                        // If dragged left past threshold, reveal
                        if finalOffset < revealThreshold {
                            dragOffset = 0
                            isRevealed = true
                        } else {
                            // Snap back
                            dragOffset = 0
                            isRevealed = false
                        }
                    }
                }
            }
    }
    
    // MARK: - Actions
    
    private func handleAction(_ action: SwipeAction) {
        // Provide haptic feedback
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        
        // Execute the action
        action.action()
        
        // Dismiss the swipe actions after a short delay to allow UI updates
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            dismissActions()
        }
    }
    
    private func dismissActions() {
        withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
            dragOffset = 0
            isRevealed = false
        }
    }
}

// MARK: - Previews

#Preview("With MealCard - All Actions") {
    VStack(spacing: AppTheme.Spacing.md) {
        Text("Swipe left to reveal actions")
            .font(AppTheme.Typography.captionLarge)
            .foregroundColor(AppTheme.Colors.textSecondary)
        
        SwipeableCard(
            actions: [
                .add { print("Add tapped") },
                .favorite(isFavorite: false) { print("Favorite tapped") },
                .delete { print("Delete tapped") }
            ]
        ) {
            MealCard(
                title: "Greek Yogurt with Berries",
                calories: 348,
                protein: 9,
                carbs: 28,
                fat: 21,
                time: "9:37 AM",
                image: nil
            )
        }
    }
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("Favorited State") {
    SwipeableCard(
        actions: [
            .add { },
            .favorite(isFavorite: true) { },
            .delete { }
        ]
    ) {
        MealCard(
            title: "Salmon Salad",
            calories: 540,
            protein: 35,
            carbs: 12,
            fat: 32,
            time: "1:15 PM",
            image: nil
        )
    }
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("Delete Only - Full Swipe") {
    VStack(spacing: AppTheme.Spacing.md) {
        Text("Full swipe enabled - swipe all the way to delete")
            .font(AppTheme.Typography.captionSmall)
            .foregroundColor(AppTheme.Colors.textSecondary)
        
        SwipeableCard(
            actions: [.delete { print("Deleted!") }],
            enableFullSwipe: true
        ) {
            MealCard(
                title: "Quick Snack",
                calories: 150,
                protein: 5,
                carbs: 20,
                fat: 5,
                time: "3:45 PM",
                image: nil
            )
        }
    }
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("Two Actions") {
    SwipeableCard(
        actions: [
            .edit { print("Edit") },
            .delete { print("Delete") }
        ]
    ) {
        MealCard(
            title: "Breakfast Wrap",
            calories: 420,
            protein: 18,
            carbs: 45,
            fat: 15,
            time: "7:30 AM",
            image: nil
        )
    }
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("No Actions (Read-only)") {
    VStack(spacing: AppTheme.Spacing.md) {
        Text("No swipe actions - behaves as normal card")
            .font(AppTheme.Typography.captionSmall)
            .foregroundColor(AppTheme.Colors.textSecondary)
        
        SwipeableCard(actions: []) {
            MealCard(
                title: "Coffee with Milk",
                calories: 26,
                protein: 2,
                carbs: 3,
                fat: 1,
                time: "11:04 AM",
                image: nil
            )
        }
    }
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("Multiple Cards in ScrollView") {
    ScrollView {
        VStack(spacing: AppTheme.Spacing.sm) {
            ForEach(0..<5) { index in
                SwipeableCard(
                    actions: [
                        .add { print("Add \(index)") },
                        .favorite(isFavorite: index == 1) { print("Favorite \(index)") },
                        .delete { print("Delete \(index)") }
                    ]
                ) {
                    MealCard(
                        title: "Meal \(index + 1)",
                        calories: 300 + index * 50,
                        protein: 15 + index * 5,
                        carbs: 30 + index * 10,
                        fat: 10 + index * 3,
                        time: "\(8 + index):00 AM",
                        image: nil
                    )
                }
            }
        }
        .padding()
    }
    .background(AppTheme.Colors.background)
}

#Preview("Dark Mode") {
    SwipeableCard(
        actions: [
            .add { },
            .favorite(isFavorite: false) { },
            .delete { }
        ]
    ) {
        MealCard(
            title: "Evening Meal",
            calories: 650,
            protein: 40,
            carbs: 55,
            fat: 25,
            time: "7:30 PM",
            image: nil
        )
    }
    .padding()
    .background(AppTheme.Colors.background)
    .preferredColorScheme(.dark)
}

#Preview("Large Dynamic Type") {
    SwipeableCard(
        actions: [
            .add { },
            .delete { }
        ]
    ) {
        MealCard(
            title: "Kaffe med mjölk",
            calories: 26,
            protein: 2,
            carbs: 3,
            fat: 1,
            time: "11:04",
            image: nil
        )
    }
    .padding()
    .background(AppTheme.Colors.background)
    .environment(\.dynamicTypeSize, .accessibility2)
}

#Preview("Single Add Action") {
    VStack(spacing: AppTheme.Spacing.md) {
        Text("Single action example")
            .font(AppTheme.Typography.captionLarge)
            .foregroundColor(AppTheme.Colors.textSecondary)
        
        SwipeableCard(
            actions: [
                .add { print("Add to diary") }
            ]
        ) {
            MealCard(
                title: "Favorite Smoothie",
                calories: 280,
                protein: 12,
                carbs: 45,
                fat: 8,
                time: "8:15 AM",
                image: nil
            )
        }
    }
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("Edit and Favorite Actions") {
    VStack(spacing: AppTheme.Spacing.md) {
        Text("Edit + Favorite combination")
            .font(AppTheme.Typography.captionSmall)
            .foregroundColor(AppTheme.Colors.textSecondary)
        
        SwipeableCard(
            actions: [
                .edit { print("Edit meal") },
                .favorite(isFavorite: false) { print("Toggle favorite") }
            ]
        ) {
            MealCard(
                title: "Custom Protein Bowl",
                calories: 485,
                protein: 42,
                carbs: 38,
                fat: 18,
                time: "12:30 PM",
                image: nil
            )
        }
    }
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("All Action Types") {
    VStack(spacing: AppTheme.Spacing.md) {
        Text("Showcasing all available actions")
            .font(AppTheme.Typography.captionLarge)
            .foregroundColor(AppTheme.Colors.textSecondary)
        
        VStack(spacing: AppTheme.Spacing.sm) {
            // Add only
            SwipeableCard(actions: [.add { }]) {
                MealCard(title: "Add Action", calories: 100, protein: 5, carbs: 10, fat: 3, time: "8:00 AM", image: nil)
            }
            
            // Edit only
            SwipeableCard(actions: [.edit { }]) {
                MealCard(title: "Edit Action", calories: 200, protein: 10, carbs: 20, fat: 6, time: "10:00 AM", image: nil)
            }
            
            // Favorite (unfilled)
            SwipeableCard(actions: [.favorite(isFavorite: false) { }]) {
                MealCard(title: "Favorite (Off)", calories: 300, protein: 15, carbs: 30, fat: 9, time: "12:00 PM", image: nil)
            }
            
            // Favorite (filled)
            SwipeableCard(actions: [.favorite(isFavorite: true) { }]) {
                MealCard(title: "Favorite (On)", calories: 400, protein: 20, carbs: 40, fat: 12, time: "2:00 PM", image: nil)
            }
            
            // Delete only
            SwipeableCard(actions: [.delete { }]) {
                MealCard(title: "Delete Action", calories: 500, protein: 25, carbs: 50, fat: 15, time: "4:00 PM", image: nil)
            }
        }
    }
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("Full Swipe Enabled") {
    VStack(spacing: AppTheme.Spacing.lg) {
        VStack(spacing: AppTheme.Spacing.xs) {
            Text("Full Swipe: ON")
                .font(AppTheme.Typography.heading3)
                .foregroundColor(AppTheme.Colors.textPrimary)
            Text("Swipe all the way left to instantly delete")
                .font(AppTheme.Typography.captionSmall)
                .foregroundColor(AppTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        
        SwipeableCard(
            actions: [
                .edit { print("Edit") },
                .delete { print("Deleted!") }
            ],
            enableFullSwipe: true
        ) {
            MealCard(
                title: "Double Espresso",
                calories: 10,
                protein: 0,
                carbs: 2,
                fat: 0,
                time: "6:45 AM",
                image: nil
            )
        }
        
        Divider()
            .padding(.vertical)
        
        VStack(spacing: AppTheme.Spacing.xs) {
            Text("Full Swipe: OFF")
                .font(AppTheme.Typography.heading3)
                .foregroundColor(AppTheme.Colors.textPrimary)
            Text("Swipe to reveal, then tap delete button")
                .font(AppTheme.Typography.captionSmall)
                .foregroundColor(AppTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        
        SwipeableCard(
            actions: [
                .edit { print("Edit") },
                .delete { print("Deleted!") }
            ],
            enableFullSwipe: false
        ) {
            MealCard(
                title: "Green Tea",
                calories: 2,
                protein: 0,
                carbs: 0,
                fat: 0,
                time: "3:30 PM",
                image: nil
            )
        }
    }
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("Compact Card Height") {
    VStack(spacing: AppTheme.Spacing.md) {
        Text("Custom compact card height")
            .font(AppTheme.Typography.captionLarge)
            .foregroundColor(AppTheme.Colors.textSecondary)
        
        SwipeableCard(
            actions: [
                .favorite(isFavorite: false) { },
                .delete { }
            ],
            cardHeight: 60
        ) {
            HStack(spacing: AppTheme.Spacing.sm) {
                Image(systemName: "cup.and.saucer.fill")
                    .font(.system(size: 24))
                    .foregroundColor(AppTheme.Colors.accent)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Quick Snack")
                        .font(AppTheme.Typography.bodyMedium)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                    
                    Text("150 cal • 10:30 AM")
                        .font(AppTheme.Typography.captionSmall)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                
                Spacer()
            }
            .padding(AppTheme.Spacing.md)
            .frame(maxWidth: .infinity)
            .background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.CornerRadius.md)
        }
    }
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("Wide Action Buttons") {
    VStack(spacing: AppTheme.Spacing.md) {
        Text("Custom wider action buttons (90pt)")
            .font(AppTheme.Typography.captionLarge)
            .foregroundColor(AppTheme.Colors.textSecondary)
        
        SwipeableCard(
            actions: [
                .add { },
                .delete { }
            ]
        ) {
            MealCard(
                title: "Wide Actions Demo",
                calories: 375,
                protein: 18,
                carbs: 42,
                fat: 14,
                time: "1:45 PM",
                image: nil
            )
        }
    }
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("Real-World Meal History") {
    ScrollView {
        VStack(spacing: AppTheme.Spacing.md) {
            Text("Today's Meals")
                .font(AppTheme.Typography.heading2)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: AppTheme.Spacing.sm) {
                SwipeableCard(
                    actions: [
                        .edit { print("Edit breakfast") },
                        .favorite(isFavorite: true) { print("Toggle") },
                        .delete { print("Delete") }
                    ]
                ) {
                    MealCard(
                        title: "Overnight Oats with Banana",
                        calories: 380,
                        protein: 12,
                        carbs: 68,
                        fat: 8,
                        time: "7:15 AM",
                        image: nil
                    )
                }
                
                SwipeableCard(
                    actions: [
                        .add { print("Add again") },
                        .favorite(isFavorite: false) { print("Toggle") },
                        .delete { print("Delete") }
                    ]
                ) {
                    MealCard(
                        title: "Mid-Morning Snack",
                        calories: 150,
                        protein: 8,
                        carbs: 15,
                        fat: 7,
                        time: "10:30 AM",
                        image: nil
                    )
                }
                
                SwipeableCard(
                    actions: [
                        .edit { print("Edit lunch") },
                        .delete { print("Delete") }
                    ]
                ) {
                    MealCard(
                        title: "Grilled Chicken Salad",
                        calories: 420,
                        protein: 38,
                        carbs: 22,
                        fat: 18,
                        time: "12:45 PM",
                        image: nil
                    )
                }
                
                SwipeableCard(
                    actions: [
                        .add { print("Add again") },
                        .favorite(isFavorite: true) { print("Toggle") },
                        .delete { print("Delete") }
                    ],
                    enableFullSwipe: true
                ) {
                    MealCard(
                        title: "Protein Shake",
                        calories: 180,
                        protein: 25,
                        carbs: 12,
                        fat: 3,
                        time: "3:00 PM",
                        image: nil
                    )
                }
            }
        }
        .padding()
    }
    .background(AppTheme.Colors.background)
}

#Preview("Interactive Tutorial") {
    VStack(spacing: AppTheme.Spacing.xl) {
        VStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: "hand.draw")
                .font(.system(size: 48))
                .foregroundColor(AppTheme.Colors.accent)
            
            Text("Swipe Gestures")
                .font(AppTheme.Typography.heading2)
                .foregroundColor(AppTheme.Colors.textPrimary)
            
            Text("Try swiping the cards below to discover actions")
                .font(AppTheme.Typography.bodySmall)
                .foregroundColor(AppTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, AppTheme.Spacing.xl)
        
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack(spacing: AppTheme.Spacing.sm) {
                Image(systemName: "arrow.left")
                    .foregroundColor(AppTheme.Colors.textSecondary)
                Text("Swipe left to reveal actions")
                    .font(AppTheme.Typography.captionLarge)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            
            SwipeableCard(
                actions: [
                    .add { },
                    .favorite(isFavorite: false) { },
                    .delete { }
                ]
            ) {
                MealCard(
                    title: "Basic Swipe",
                    calories: 200,
                    protein: 10,
                    carbs: 25,
                    fat: 8,
                    time: "Now",
                    image: nil
                )
            }
            
            HStack(spacing: AppTheme.Spacing.sm) {
                Image(systemName: "arrow.left.to.line")
                    .foregroundColor(AppTheme.Colors.destructive)
                Text("Swipe all the way to quick delete")
                    .font(AppTheme.Typography.captionLarge)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            .padding(.top, AppTheme.Spacing.sm)
            
            SwipeableCard(
                actions: [.delete { }],
                enableFullSwipe: true
            ) {
                MealCard(
                    title: "Full Swipe Delete",
                    calories: 100,
                    protein: 5,
                    carbs: 12,
                    fat: 4,
                    time: "Now",
                    image: nil
                )
            }
        }
        
        Spacer()
    }
    .padding()
    .background(AppTheme.Colors.background)
}



