import Foundation

/// Streamlined spacing system with 6 core values.
/// Compose for larger gaps rather than adding more tokens.
struct Spacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    
    // MARK: - Component-Specific (derived, not new tokens)
    // Prefer composition over new constants
    static var cardPadding: CGFloat { md }
    static var screenMargin: CGFloat { md }
    static var sectionSpacing: CGFloat { lg }
    static var componentGap: CGFloat { sm }
}
