# Cursor AI Workflow for CalSnap

## How to Use This Document

This project is designed to be built incrementally with Cursor AI assistance. Follow these guidelines:

## 1. Before Starting a New File

1. Read the relevant section in the main specification
2. Check if related components already exist
3. Identify which mock data you'll need

## 2. Prompting Pattern

Use this template:

```
Create a SwiftUI [component/screen] for CalSnap that:
- Follows the design system in DesignSystem/Theme/AppTheme.swift
- Uses mock data from Core/MockData/MockData.swift
- Includes 3+ preview variants (default, edge case, dark mode)
- Implements accessibility labels
- Has no business logic (UI only)

Specific requirements: [List specific requirements from spec]
```

## 3. After Code Generation

1. **Compile immediately** - Fix any errors before proceeding
2. **Check previews** - All variants should render
3. **Test dark mode** - Toggle and verify
4. **Test Dynamic Type** - Increase text size
5. **Commit** - Small, working increments

## 4. File-by-File Approach

Build in this order:
1. Theme files (if not done)
2. Simple components (buttons, cards)
3. Complex components (sliders, lists)
4. Screens (home, detail, settings)
5. Navigation shell
6. Polish and accessibility

## 5. Common Issues & Fixes

### Issue: Component doesn't compile
**Fix**: Check import statements, ensure AppTheme is accessible

### Issue: Preview crashes
**Fix**: Verify mock data exists, check for force-unwraps

### Issue: Colors look wrong
**Fix**: Use AppTheme.Colors, not hard-coded values

### Issue: Text gets clipped
**Fix**: Use `.fixedSize(horizontal: false, vertical: true)` or `.lineLimit(nil)`

## 6. Quality Checklist

Before marking a component "done":
- [ ] Compiles without warnings
- [ ] All previews work
- [ ] Dark mode tested
- [ ] Large text tested
- [ ] Uses AppTheme exclusively
- [ ] No business logic in View
- [ ] Accessibility labels present
- [ ] No TODOs or placeholder comments

## 7. Getting Unstuck

If Cursor generates incorrect code:
1. Reference the specific section in the main spec
2. Show the existing design system files
3. Provide a working example of a similar component
4. Ask for "refactor to match this pattern"

## 8. Progressive Enhancement

Build in layers:
1. **Structure** - Layout and static content
2. **Styling** - Colors, spacing, typography
3. **Interaction** - Buttons, gestures
4. **States** - Loading, empty, error
5. **Accessibility** - VoiceOver, Dynamic Type
6. **Polish** - Animations, haptics

