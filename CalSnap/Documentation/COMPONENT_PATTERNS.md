# Component Building Patterns

## Anatomy of a Good Component

```swift
import SwiftUI

struct MyComponent: View {
    // 1. Props (dependencies injected)
    let data: SomeData
    let onAction: () -> Void
    
    // 2. State (internal only)
    @State private var isExpanded = false
    
    // 3. Body
    var body: some View {
        // UI here
    }
}

// 4. Previews (MANDATORY)
#Preview("Default") {
    MyComponent(
        data: MockData.sample,
        onAction: {}
    )
}

#Preview("Edge Case") {
    MyComponent(
        data: MockData.edgeCase,
        onAction: {}
    )
}

#Preview("Dark Mode") {
    MyComponent(
        data: MockData.sample,
        onAction: {}
    )
    .preferredColorScheme(.dark)
}
```

## Common Patterns

### Card Container
Always wrap content in `CardContainer`:

```swift
CardContainer {
    VStack {
        // Content
    }
}
```

### Progress Indicators
Use consistent progress bar styling:

```swift
GeometryReader { geometry in
    ZStack(alignment: .leading) {
        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.full)
            .fill(AppTheme.Colors.UI.textTertiary.opacity(0.2))
            .frame(height: 8)
        
        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.full)
            .fill(AppTheme.Colors.Domain.calories)
            .frame(width: geometry.size.width * progress, height: 8)
    }
}
.frame(height: 8)
```

### Buttons
Use design system buttons:

```swift
PrimaryButton(
    title: "Analyze",
    icon: "camera",
    action: { }
)
```

## Anti-Patterns (DON'T DO)
- ❌ Hard-coded colors: `Color.blue`
- ❌ Hard-coded fonts: `Font.system(size: 16)`
- ❌ Hard-coded spacing: `.padding(12)`
- ❌ No previews
- ❌ ViewModels in UI files
- ❌ Business logic in Views

