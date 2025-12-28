# CalSnap Design Guidelines

## Visual Hierarchy
1. **Primary actions**: Green buttons, prominent placement
2. **Calories**: Largest number, orange color (#F97316)
3. **Macros**: Color-coded pills (Protein: Pink, Carbs: Green, Fat: Blue)
4. **Warnings**: Orange/red allergen badges

## Spacing Rules
- Card padding: 16pt
- Section spacing: 24pt
- Component gaps: 12pt
- Never use raw numbers - always use `AppTheme.Spacing.[size]`

## Typography
- Numbers: SF Pro Rounded, Semibold
- Body text: SF Pro Text, Regular
- Headlines: SF Pro Display, Bold
- Always support Dynamic Type

## Colors
- Use semantic names: `AppTheme.Colors.primary`, NOT `Color.green`
- All colors must have dark mode variants
- Reference the ColorPalette.swift file

## Interactions
- All buttons must have haptic feedback
- Sliders should have haptic feedback at key percentages (50%, 100%, 150%, 200%)
- Loading states are mandatory for async operations
- Empty states must have helpful CTAs

