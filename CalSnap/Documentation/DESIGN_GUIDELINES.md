# CalSnap Design System for Cursor

> Copy-paste ready SwiftUI code snippets and design tokens for AI-assisted development
> 

---

## Quick Reference: Design Tokens

### Colors (Copy These)

```swift
// MARK: - CalSnap Colors
extension Color {
    // Primary Accent
    static let csGolden = Color(hex: "#FFD60A")
    static let csGoldenBorder = Color(hex: "#FFC107")

    // Warm Tones
    static let csOrange = Color(hex: "#FF9500")
    static let csRed = Color(hex: "#FF3B30")

    // Macros
    static let csProtein = Color(hex: "#FF2D92")
    static let csCarbs = Color(hex: "#34C759")
    static let csFat = Color(hex: "#007AFF")

    // Text
    static let csTertiary = Color(hex: "#8E8E93")

    // Dark Mode Card
    static let csDarkCard = Color(hex: "#1C1C1E")
}

// Hex initializer (add to project once)
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

```

### Spacing & Radii

```swift
// MARK: - CalSnap Spacing
enum CSSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
    static let xxxl: CGFloat = 32
}

// MARK: - CalSnap Corner Radius
enum CSRadius {
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 20
    static let xl: CGFloat = 24
    static let pill: CGFloat = 18
    static let round: CGFloat = 28
}

```

---

## Glass Card Modifiers (Copy These)

### Standard Glass Card

```swift
// MARK: - Glass Card Modifier
struct GlassCard: ViewModifier {
    var cornerRadius: CGFloat = 20

    func body(content: Content) -> some View {
        content
            .padding(CSSpacing.xl)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.thinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
            )
    }
}

extension View {
    func glassCard(cornerRadius: CGFloat = 20) -> some View {
        modifier(GlassCard(cornerRadius: cornerRadius))
    }
}

// Usage:
// YourContent().glassCard()

```

### Active State Glass (Golden Border)

```swift
// MARK: - Active Glass Card Modifier
struct ActiveGlassCard: ViewModifier {
    var isActive: Bool
    var cornerRadius: CGFloat = 28

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.thinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .stroke(
                                isActive ? Color.csGolden : .white.opacity(0.2),
                                lineWidth: isActive ? 2 : 1
                            )
                    )
                    .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
            )
            .animation(.easeInOut(duration: 0.2), value: isActive)
    }
}

extension View {
    func activeGlassCard(isActive: Bool, cornerRadius: CGFloat = 28) -> some View {
        modifier(ActiveGlassCard(isActive: isActive, cornerRadius: cornerRadius))
    }
}

```

---

## Ready-to-Use Components

### 1. Stats Card (Calorie Display)

```swift
struct CalorieStatsCard: View {
    let consumed: Int
    let goal: Int
    let mealCount: Int

    private var progress: Double {
        Double(consumed) / Double(goal)
    }

    private var percentage: Int {
        Int(progress * 100)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Text("TODAY")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)

                Spacer()

                Text("\(mealCount) MEALS")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }

            // Calorie Display
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Image(systemName: "flame.fill")
                        .font(.title2)
                        .foregroundStyle(.orange.gradient)

                    Text("\(consumed)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))

                    Text("/ \(goal) kcal")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }

                // Progress Bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.quaternary)
                            .frame(height: 8)

                        Capsule()
                            .fill(.orange.gradient)
                            .frame(width: geo.size.width * min(progress, 1.0), height: 8)
                            .shadow(color: .orange.opacity(0.3), radius: 4, y: 2)
                    }
                }
                .frame(height: 8)

                // Percentage
                HStack {
                    Spacer()
                    Text("\(percentage)%")
                        .font(.system(.title, design: .rounded, weight: .bold))
                        .foregroundStyle(.orange.gradient)
                }
            }
        }
        .glassCard()
    }
}

// Usage:
// CalorieStatsCard(consumed: 714, goal: 2000, mealCount: 2)

```

### 2. Macro Progress Row

```swift
struct MacroProgressRow: View {
    let icon: String
    let label: String
    let current: Int
    let goal: Int
    let color: Color

    private var progress: Double {
        Double(current) / Double(goal)
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color.gradient)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(label.uppercased())
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text("\(current)/\(goal) g")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.quaternary)
                            .frame(height: 6)

                        Capsule()
                            .fill(color.gradient)
                            .frame(width: geo.size.width * min(progress, 1.0), height: 6)
                            .shadow(color: color.opacity(0.3), radius: 3, y: 1)
                    }
                }
                .frame(height: 6)
            }
        }
    }
}

// Usage in a macros card:
// VStack(spacing: 16) {
//     MacroProgressRow(icon: "fork.knife.circle.fill", label: "Protein", current: 34, goal: 150, color: .csProtein)
//     MacroProgressRow(icon: "leaf.circle.fill", label: "Carbs", current: 122, goal: 200, color: .csCarbs)
//     MacroProgressRow(icon: "drop.circle.fill", label: "Fat", current: 14, goal: 67, color: .csFat)
// }
// .glassCard()

```

### 3. Meal Photo Card

```swift
struct MealPhotoCard: View {
    let imageURL: URL?
    let title: String
    let calories: Int
    var onDelete: (() -> Void)?

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Photo with gradient overlay
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(.quaternary)
                    .overlay {
                        Image(systemName: "fork.knife")
                            .font(.largeTitle)
                            .foregroundStyle(.tertiary)
                    }
            }
            .frame(width: 160, height: 160)
            .clipShape(RoundedRectangle(cornerRadius: CSRadius.lg, style: .continuous))
            .overlay {
                LinearGradient(
                    colors: [.clear, .black.opacity(0.6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .clipShape(RoundedRectangle(cornerRadius: CSRadius.lg, style: .continuous))
            }
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.white)

                    Text("\(calories) kcal")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                }
                .padding(12)
            }

            // Delete button
            if let onDelete {
                Button(action: onDelete) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .background {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 32, height: 32)
                        }
                }
                .padding(8)
            }
        }
        .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
    }
}

```

### 4. Language Selector Pill

```swift
struct LanguagePill: View {
    @Binding var selectedLanguage: String
    @State private var isExpanded = false
    let languages = ["EN", "SV"]

    var body: some View {
        Group {
            if isExpanded {
                // Expanded selector
                HStack(spacing: 0) {
                    ForEach(languages, id: \.self) { lang in
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                selectedLanguage = lang
                                isExpanded = false
                            }
                        } label: {
                            Text(lang)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(selectedLanguage == lang ? .white : .primary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background {
                                    if selectedLanguage == lang {
                                        Capsule()
                                            .fill(Color.csGolden)
                                    }
                                }
                        }
                    }
                }
                .background(
                    Capsule()
                        .fill(Color(uiColor: .systemGray5))
                )
            } else {
                // Collapsed pill
                Button {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                        isExpanded = true
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "mic.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.white)

                        Rectangle()
                            .fill(.white.opacity(0.4))
                            .frame(width: 1, height: 16)

                        Text(selectedLanguage)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.csGolden)
                            .shadow(color: .black.opacity(0.1), radius: 8, y: 2)
                    )
                }
            }
        }
        .transition(.scale.combined(with: .opacity))
    }
}

```

### 5. Bottom Input Bar

```swift
struct BottomInputBar: View {
    @Binding var text: String
    @Binding var isRecording: Bool
    @FocusState private var isFocused: Bool

    var onCamera: () -> Void
    var onMicrophone: () -> Void
    var onFavorites: () -> Void
    var onSend: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Camera button
            Button(action: onCamera) {
                Image(systemName: "camera")
                    .font(.system(size: 20))
                    .foregroundStyle(.secondary)
                    .frame(width: 44, height: 44)
            }

            // Text field
            TextField("Add a meal...", text: $text, axis: .vertical)
                .font(.body)
                .lineLimit(1...4)
                .focused($isFocused)

            // Microphone button
            Button(action: onMicrophone) {
                Image(systemName: "mic.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(isRecording ? Color.csRed : .secondary)
                    .frame(width: 44, height: 44)
            }

            // Favorites / Send button
            Button(action: text.isEmpty ? onFavorites : onSend) {
                Image(systemName: text.isEmpty ? "heart" : "arrow.up.circle.fill")
                    .font(.system(size: text.isEmpty ? 20 : 28))
                    .foregroundStyle(text.isEmpty ? .secondary : Color.csGolden)
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, CSSpacing.lg)
        .padding(.vertical, CSSpacing.md)
        .activeGlassCard(isActive: isRecording)
        .padding(.horizontal, CSSpacing.lg)
        .padding(.bottom, CSSpacing.sm)
    }
}

```

---

## Typography Presets

```swift
// MARK: - CalSnap Typography
extension View {
    // Display - Large calorie numbers
    func csDisplay() -> some View {
        self.font(.system(size: 48, weight: .bold, design: .rounded))
    }

    // Title 1 - Screen titles
    func csTitle1() -> some View {
        self.font(.system(size: 34, weight: .bold))
    }

    // Title 2 - Section headers
    func csTitle2() -> some View {
        self.font(.system(size: 28, weight: .bold))
    }

    // Title 3 - Card headers
    func csTitle3() -> some View {
        self.font(.system(size: 22, weight: .semibold))
    }

    // Headline - Emphasized body
    func csHeadline() -> some View {
        self.font(.system(size: 17, weight: .semibold))
    }

    // Subheadline - Labels
    func csSubheadline() -> some View {
        self.font(.system(size: 15, weight: .medium))
    }

    // Footnote - Timestamps
    func csFootnote() -> some View {
        self.font(.system(size: 13, weight: .regular))
    }
}

```

---

## Animation Presets

```swift
// MARK: - CalSnap Animations
extension Animation {
    // Quick feedback (button taps)
    static let csQuick = Animation.easeInOut(duration: 0.2)

    // Standard transitions
    static let csStandard = Animation.easeInOut(duration: 0.3)

    // Natural spring
    static let csSpring = Animation.spring(response: 0.3, dampingFraction: 0.75)

    // Bouncy spring (playful)
    static let csBouncy = Animation.spring(response: 0.4, dampingFraction: 0.6)

    // Smooth slides (pills, modals)
    static let csSlide = Animation.spring(response: 0.25, dampingFraction: 0.75)
}

// Usage:
// .animation(.csSpring, value: someState)

```

---

## Haptic Feedback Helper

```swift
// MARK: - Haptics
enum CSHaptics {
    static func light() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    static func medium() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    static func heavy() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }

    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    static func error() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }

    static func warning() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }
}

// Usage:
// Button { CSHaptics.light(); doSomething() }

```

---

## SF Symbols Quick Reference

```swift
// Primary Actions
"camera"                    // Add photo
"mic.fill"                  // Voice input
"arrow.up"                  // Send
"plus"                      // Add new
"xmark.circle.fill"         // Delete/close
"heart" / "heart.fill"      // Favorites

// Stats & Macros
"flame.fill"                // Calories
"fork.knife.circle.fill"    // Protein
"leaf.circle.fill"          // Carbs
"drop.circle.fill"          // Fat

// Navigation
"house.fill"                // Home
"calendar"                  // Calendar
"magnifyingglass"           // Search
"gearshape.fill"            // Settings
"person.circle.fill"        // Profile

```

---

## Empty State Template

```swift
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let buttonTitle: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 64))
                .foregroundStyle(.tertiary)

            Text(title)
                .font(.title3)
                .fontWeight(.semibold)

            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            if let buttonTitle, let action {
                Button(buttonTitle, action: action)
                    .buttonStyle(.borderedProminent)
                    .tint(Color.csGolden)
            }
        }
        .padding(40)
    }
}

// Usage:
// EmptyStateView(
//     icon: "fork.knife",
//     title: "No meals yet",
//     message: "Add your first meal to start tracking",
//     buttonTitle: "Add Meal"
// ) { addMeal() }

```

---

## Checklist for New Screens

When building a new CalSnap screen, ensure:

- [ ]  Uses `.thinMaterial` or `.ultraThinMaterial` for card backgrounds
- [ ]  Corner radius uses `.continuous` style
- [ ]  Glass cards have white 20% border overlay
- [ ]  Shadows use `black.opacity(0.08), radius: 12, y: 4`
- [ ]  Golden accent (`#FFD60A`) only for active/selected states
- [ ]  Numbers use `.rounded` design font
- [ ]  Animations use spring curves (not linear)
- [ ]  Touch targets are minimum 44x44pt
- [ ]  Haptic feedback on interactive elements
- [ ]  Supports Dynamic Type
- [ ]  Works in both light and dark mode

---

## Don'ts

- ❌ Don't stack more than 2-3 glass layers
- ❌ Don't use golden color for text (poor contrast)
- ❌ Don't mix flat and glass styles in same view
- ❌ Don't forget shadows on floating elements
- ❌ Don't use harsh/solid borders
- ❌ Don't over-animate (keep it subtle)
- ❌ Don't use bullet points in meal descriptions

---

*Last updated: December 28, 2025*