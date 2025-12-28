# Common Issues & Solutions

## Build Errors

### "Cannot find 'AppTheme' in scope"
**Cause**: Import missing or wrong target membership
**Fix**: Add `import CalSnap` or check file target

### "Type 'Meal' has no member 'mockBreakfast'"
**Cause**: MockData extension not loaded
**Fix**: Ensure MockData.swift is in target, rebuild

## Preview Issues

### Preview crashes on load
**Cause**: Mock data force-unwrap or missing
**Fix**: Check all mock data is properly initialized

### Preview shows blank screen
**Cause**: Background color matches content
**Fix**: Add explicit background or check dark mode

## Layout Issues

### Text gets clipped
**Solution**:

```swift
Text(longString)
    .fixedSize(horizontal: false, vertical: true)
    .lineLimit(nil)
```

### Content overflows card
**Solution**:

```swift
ScrollView {
    content
}
.frame(maxHeight: .infinity)
```

## Dark Mode Issues

### Colors don't adapt
**Cause**: Using hard-coded colors
**Fix**: Use AppTheme.Colors which have automatic variants

### Images too bright in dark mode
**Solution**:

```swift
Image("photo")
    .renderingMode(.original) // Don't tint
```

## Accessibility Issues

### VoiceOver reads wrong order
**Solution**:

```swift
.accessibilityElement(children: .combine)
.accessibilityLabel("Correct order text")
```

### Buttons not tappable
**Cause**: Hit area too small
**Fix**: Ensure minimum 44x44pt tap area

## Performance Issues

### List scrolling is laggy
**Solution**: Use LazyVStack instead of VStack

```swift
ScrollView {
    LazyVStack {
        ForEach(meals) { meal in
            MealCard(meal: meal)
        }
    }
}
```

### Images loading slowly
**Solution**: Use async image loading

```swift
AsyncImage(url: url) { image in
    image.resizable()
} placeholder: {
    ProgressView()
}
```

