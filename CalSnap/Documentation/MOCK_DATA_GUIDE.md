# Working with Mock Data

## Available Mock Data

### MockData.swift Structure

```swift
enum MockData {
    // Single instances
    static let sampleMeal: Meal
    static let sampleBreakfast: Meal
    static let sampleLunch: Meal
    static let sampleDinner: Meal
    
    // Collections
    static let sampleMeals: [Meal]
    static let sampleComponents: [MealComponent]
    
    // Edge cases
    static let mealWithLongName: Meal
    static let mealWithoutImage: Meal
    static let mealWithLowConfidence: Meal
    static let mealWithAllergens: Meal
    
    // Daily data
    static let sampleDailyGoals: DailyGoals
    static let sampleProgress: DailyProgress
}
```

## Creating New Mock Data

When you need new scenarios:

```swift
extension MockData {
    static let myNewScenario: Meal {
        Meal(
            id: UUID(),
            name: "Test Meal",
            calories: 500,
            protein: 30,
            carbs: 50,
            fat: 15,
            // ... rest of properties
        )
    }
}
```

## Using Mock Data in Views

```swift
struct MyView: View {
    let meal: Meal  // Injected dependency
    
    var body: some View {
        // Use meal
    }
}

#Preview {
    MyView(meal: MockData.sampleBreakfast)
}
```

## DO NOT
- ❌ Make network requests
- ❌ Access databases
- ❌ Call AI services
- ❌ Use UserDefaults
- ❌ Access file system

All data comes from MockData until Phase 11.

