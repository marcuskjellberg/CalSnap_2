import SwiftUI

/// Typography system using Apple's Dynamic Type for automatic scaling and accessibility.
/// Maps to system text styles with custom weights and designs.
struct Typography {
    // MARK: - Display (Hero text, large titles)
    static let displayLarge = Font.largeTitle.weight(.bold)
    static let displayMedium = Font.title.weight(.bold)
    static let displaySmall = Font.title2.weight(.semibold)
    
    // MARK: - Headings (Section headers, card titles)
    static let heading1 = Font.title2.weight(.bold)
    static let heading2 = Font.title3.weight(.semibold)
    static let heading3 = Font.headline.weight(.semibold)
    
    // MARK: - Body (Primary content text)
    static let bodyLarge = Font.body
    static let bodyMedium = Font.callout
    static let bodySmall = Font.subheadline
    
    // MARK: - Captions (Secondary info, timestamps)
    static let captionLarge = Font.footnote
    static let captionSmall = Font.caption
    static let captionTiny = Font.caption2
    
    // MARK: - Numbers & Data (Rounded design for metrics)
    static let numberLarge = Font.system(.largeTitle, design: .rounded).weight(.semibold)
    static let numberMedium = Font.system(.title3, design: .rounded).weight(.semibold)
    static let numberSmall = Font.system(.callout, design: .rounded).weight(.medium)
}
