import SwiftUI

/// Represents a single swipe action for use with `SwipeableCard`.
/// Each action defines an icon, optional label, background color, and callback.
struct SwipeAction: Identifiable {
    let id = UUID()
    let icon: String        // SF Symbol name
    let label: String?      // Optional text below icon
    let color: Color        // Background color
    let action: () -> Void  // Callback when tapped
    
    /// Creates a custom swipe action.
    /// - Parameters:
    ///   - icon: SF Symbol name for the button icon
    ///   - label: Optional text label below the icon
    ///   - color: Background color of the button
    ///   - action: Closure executed when the button is tapped
    init(icon: String, label: String? = nil, color: Color, action: @escaping () -> Void) {
        self.icon = icon
        self.label = label
        self.color = color
        self.action = action
    }
}

// MARK: - Preset Actions

extension SwipeAction {
    /// Add/Log action - Golden color with plus icon
    static func add(_ action: @escaping () -> Void) -> SwipeAction {
        SwipeAction(
            icon: "plus",
            label: "Add",
            color: AppTheme.Colors.accent,
            action: action
        )
    }
    
    /// Favorite toggle action - Pink color with heart icon
    /// - Parameter isFavorite: Whether the item is currently favorited (changes icon)
    static func favorite(isFavorite: Bool, _ action: @escaping () -> Void) -> SwipeAction {
        SwipeAction(
            icon: isFavorite ? "heart.fill" : "heart",
            label: "Favorite",
            color: AppTheme.Colors.protein,
            action: action
        )
    }
    
    /// Delete action - Red color with trash icon
    static func delete(_ action: @escaping () -> Void) -> SwipeAction {
        SwipeAction(
            icon: "trash.fill",
            label: "Delete",
            color: AppTheme.Colors.destructive,
            action: action
        )
    }
    
    /// Edit action - Golden color with pencil icon
    static func edit(_ action: @escaping () -> Void) -> SwipeAction {
        SwipeAction(
            icon: "pencil",
            label: "Edit",
            color: AppTheme.Colors.accent,
            action: action
        )
    }
    
    /// Share action - Blue color with share icon
    static func share(_ action: @escaping () -> Void) -> SwipeAction {
        SwipeAction(
            icon: "square.and.arrow.up",
            label: "Share",
            color: Color(red: 0, green: 122/255, blue: 1), // System blue #007AFF
            action: action
        )
    }
    
    /// Archive action - Orange color with archive icon
    static func archive(_ action: @escaping () -> Void) -> SwipeAction {
        SwipeAction(
            icon: "archivebox.fill",
            label: "Archive",
            color: Color(red: 1, green: 149/255, blue: 0), // System orange #FF9500
            action: action
        )
    }
}

