import Foundation

/// Centralized mock data for UI development and previews
enum MockData {
    
    // MARK: - Daily Goals
    
    static let sampleDailyGoals = DailyGoals(
        calorieTarget: 2000,
        proteinTarget: 150,
        carbsTarget: 200,
        fatTarget: 67,
        fiberTarget: 30,
        activityLevel: .moderatelyActive,
        goalType: .maintain
    )
    
    static let weightLossGoals = DailyGoals(
        calorieTarget: 1600,
        proteinTarget: 140,
        carbsTarget: 120,
        fatTarget: 55,
        fiberTarget: 35,
        activityLevel: .lightlyActive,
        goalType: .loseFat
    )
    
    static let muscleGainGoals = DailyGoals(
        calorieTarget: 2800,
        proteinTarget: 200,
        carbsTarget: 300,
        fatTarget: 90,
        fiberTarget: 35,
        activityLevel: .veryActive,
        goalType: .gainMass
    )
    
    // MARK: - Meal Components
    
    static let yogurtComponent = MealComponent(
        name: "Greek Yogurt",
        order: 0,
        quantity: 170,
        unit: .grams,
        familiarQuantity: 1,
        familiarUnit: "cup",
        calories: 100,
        protein: 17,
        carbs: 6,
        fat: 0.7,
        fiber: 0,
        foodCategory: .dairy,
        isLiquid: false,
        allergens: [.dairy],
        dietaryTags: [.highProtein, .lowFat],
        confidence: .high
    )
    
    static let berriesComponent = MealComponent(
        name: "Mixed Berries",
        order: 1,
        quantity: 100,
        unit: .grams,
        familiarQuantity: 0.5,
        familiarUnit: "cup",
        calories: 57,
        protein: 0.7,
        carbs: 14,
        fat: 0.3,
        fiber: 4,
        foodCategory: .fruit,
        isLiquid: false,
        allergens: [],
        dietaryTags: [.vegan, .glutenFree],
        confidence: .high
    )
    
    static let granolaComponent = MealComponent(
        name: "Granola",
        order: 2,
        quantity: 30,
        unit: .grams,
        familiarQuantity: 2,
        familiarUnit: "tbsp",
        calories: 140,
        protein: 3,
        carbs: 22,
        fat: 5,
        fiber: 2,
        foodCategory: .grain,
        isLiquid: false,
        allergens: [.nuts, .gluten],
        dietaryTags: [],
        confidence: .medium,
        uncertaintyNote: "May contain different nut types"
    )
    
    static let honeyComponent = MealComponent(
        name: "Honey",
        order: 3,
        quantity: 15,
        unit: .grams,
        familiarQuantity: 1,
        familiarUnit: "tbsp",
        calories: 64,
        protein: 0,
        carbs: 17,
        fat: 0,
        fiber: 0,
        foodCategory: .sweet,
        isLiquid: true,
        allergens: [],
        dietaryTags: [.glutenFree, .dairyFree],
        confidence: .high
    )
    
    static let salmonComponent = MealComponent(
        name: "Grilled Salmon",
        order: 0,
        quantity: 150,
        unit: .grams,
        familiarQuantity: 1,
        familiarUnit: "fillet",
        calories: 280,
        protein: 39,
        carbs: 0,
        fat: 13,
        fiber: 0,
        foodCategory: .protein,
        isLiquid: false,
        allergens: [.fish],
        dietaryTags: [.highProtein, .lowCarb, .keto, .paleo],
        confidence: .high
    )
    
    static let saladComponent = MealComponent(
        name: "Mixed Greens",
        order: 1,
        quantity: 100,
        unit: .grams,
        familiarQuantity: 2,
        familiarUnit: "cups",
        calories: 20,
        protein: 2,
        carbs: 3,
        fat: 0.3,
        fiber: 2,
        foodCategory: .vegetable,
        isLiquid: false,
        allergens: [],
        dietaryTags: [.vegan, .glutenFree, .lowCarb],
        confidence: .high
    )
    
    static let oliveOilComponent = MealComponent(
        name: "Olive Oil Dressing",
        order: 2,
        quantity: 15,
        unit: .milliliters,
        familiarQuantity: 1,
        familiarUnit: "tbsp",
        calories: 120,
        protein: 0,
        carbs: 0,
        fat: 14,
        fiber: 0,
        foodCategory: .fat,
        isLiquid: true,
        allergens: [],
        dietaryTags: [.vegan, .glutenFree, .keto],
        confidence: .high
    )
    
    static let coffeeComponent = MealComponent(
        name: "Black Coffee",
        order: 0,
        quantity: 240,
        unit: .milliliters,
        familiarQuantity: 1,
        familiarUnit: "cup",
        calories: 2,
        protein: 0.3,
        carbs: 0,
        fat: 0,
        fiber: 0,
        foodCategory: .beverage,
        isLiquid: true,
        allergens: [],
        dietaryTags: [.vegan, .glutenFree, .keto],
        confidence: .high
    )
    
    static let milkComponent = MealComponent(
        name: "Whole Milk",
        order: 1,
        quantity: 30,
        unit: .milliliters,
        familiarQuantity: 2,
        familiarUnit: "tbsp",
        calories: 18,
        protein: 1,
        carbs: 1.5,
        fat: 1,
        fiber: 0,
        foodCategory: .dairy,
        isLiquid: true,
        allergens: [.dairy],
        dietaryTags: [],
        confidence: .high
    )
    
    static let sampleComponents: [MealComponent] = [
        yogurtComponent,
        berriesComponent,
        granolaComponent,
        honeyComponent,
        salmonComponent,
        saladComponent,
        oliveOilComponent
    ]
    
    // MARK: - Meals
    
    static let sampleBreakfast = Meal(
        timestamp: Calendar.current.date(bySettingHour: 8, minute: 30, second: 0, of: Date())!,
        mealType: .breakfast,
        name: "Greek Yogurt with Berries",
        summary: "Creamy Greek yogurt topped with fresh berries, granola, and honey",
        calories: 361,
        protein: 21,
        carbs: 59,
        fat: 6,
        fiber: 6,
        healthScore: .good,
        healthInsights: [
            "High in protein for muscle recovery",
            "Good source of probiotics",
            "Contains antioxidants from berries"
        ],
        allergens: [.dairy, .nuts, .gluten],
        dietaryTags: [.highProtein],
        confidence: .high,
        components: [yogurtComponent, berriesComponent, granolaComponent, honeyComponent]
    )
    
    static let sampleLunch = Meal(
        timestamp: Calendar.current.date(bySettingHour: 12, minute: 30, second: 0, of: Date())!,
        mealType: .lunch,
        name: "Grilled Salmon Salad",
        summary: "Fresh grilled salmon over mixed greens with olive oil dressing",
        calories: 420,
        protein: 41,
        carbs: 3,
        fat: 27,
        fiber: 2,
        healthScore: .excellent,
        healthInsights: [
            "Excellent source of omega-3 fatty acids",
            "High protein, low carb meal",
            "Rich in vitamins and minerals"
        ],
        allergens: [.fish],
        dietaryTags: [.highProtein, .lowCarb, .keto, .paleo, .glutenFree],
        confidence: .high,
        components: [salmonComponent, saladComponent, oliveOilComponent]
    )
    
    static let sampleDinner = Meal(
        timestamp: Calendar.current.date(bySettingHour: 19, minute: 0, second: 0, of: Date())!,
        mealType: .dinner,
        name: "Chicken Stir-Fry with Rice",
        summary: "Tender chicken breast with vegetables and jasmine rice",
        calories: 580,
        protein: 42,
        carbs: 65,
        fat: 14,
        fiber: 5,
        healthScore: .good,
        healthInsights: [
            "Balanced macronutrient profile",
            "Good source of lean protein",
            "Contains variety of vegetables"
        ],
        allergens: [.soy, .gluten],
        dietaryTags: [.highProtein],
        confidence: .high,
        components: []
    )
    
    static let sampleSnack = Meal(
        timestamp: Calendar.current.date(bySettingHour: 15, minute: 30, second: 0, of: Date())!,
        mealType: .snack,
        name: "Apple with Almond Butter",
        summary: "Fresh apple slices with natural almond butter",
        calories: 267,
        protein: 6,
        carbs: 32,
        fat: 15,
        fiber: 6,
        healthScore: .good,
        healthInsights: [
            "Good source of healthy fats",
            "High in fiber",
            "Natural energy boost"
        ],
        allergens: [.nuts],
        dietaryTags: [.vegan, .glutenFree, .dairyFree, .paleo],
        confidence: .high,
        components: []
    )
    
    static let coffeeSnack = Meal(
        timestamp: Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!,
        mealType: .snack,
        name: "Coffee with Milk",
        summary: "Fresh brewed coffee with a splash of whole milk",
        calories: 20,
        protein: 1,
        carbs: 2,
        fat: 1,
        fiber: 0,
        healthScore: .moderate,
        healthInsights: [
            "Low calorie beverage",
            "Contains caffeine for alertness"
        ],
        allergens: [.dairy],
        dietaryTags: [.glutenFree],
        confidence: .high,
        components: [coffeeComponent, milkComponent]
    )
    
    static let sampleMeal = sampleBreakfast
    
    static let sampleMeals: [Meal] = [
        sampleBreakfast,
        coffeeSnack,
        sampleLunch,
        sampleSnack,
        sampleDinner
    ]
    
    // MARK: - Edge Cases
    
    static let mealWithLongName = Meal(
        timestamp: Date(),
        mealType: .lunch,
        name: "Mediterranean Grilled Chicken Salad with Feta Cheese, Kalamata Olives, and Lemon Herb Vinaigrette",
        summary: "A delicious and healthy Mediterranean-inspired salad",
        calories: 450,
        protein: 35,
        carbs: 20,
        fat: 28,
        fiber: 6,
        healthScore: .excellent,
        healthInsights: [],
        allergens: [.dairy],
        dietaryTags: [.highProtein, .lowCarb],
        confidence: .high,
        components: []
    )
    
    static let mealWithoutImage = Meal(
        timestamp: Date(),
        mealType: .breakfast,
        name: "Oatmeal with Banana",
        summary: nil,
        imageData: nil,
        calories: 350,
        protein: 10,
        carbs: 65,
        fat: 7,
        fiber: 8,
        healthScore: .good,
        healthInsights: [],
        allergens: [.gluten],
        dietaryTags: [.vegan, .dairyFree],
        confidence: .high,
        components: []
    )
    
    static let mealWithLowConfidence = Meal(
        timestamp: Date(),
        mealType: .dinner,
        name: "Mystery Casserole",
        summary: "Unable to identify all ingredients",
        calories: 500,
        protein: 25,
        carbs: 45,
        fat: 22,
        fiber: 3,
        healthScore: .unknown,
        healthInsights: [
            "Nutritional values are estimates",
            "Consider logging individual ingredients"
        ],
        allergens: [],
        dietaryTags: [],
        confidence: .low,
        uncertaintyNotes: [
            "Could not identify sauce type",
            "Protein source unclear - possibly chicken or pork"
        ],
        components: []
    )
    
    static let mealWithAllergens = Meal(
        timestamp: Date(),
        mealType: .lunch,
        name: "Pad Thai with Shrimp",
        summary: "Classic Thai noodle dish with shrimp and peanuts",
        calories: 620,
        protein: 28,
        carbs: 78,
        fat: 22,
        fiber: 4,
        healthScore: .moderate,
        healthInsights: [
            "High in sodium",
            "Good protein source"
        ],
        allergens: [.shellfish, .peanuts, .soy, .eggs, .gluten],
        dietaryTags: [],
        confidence: .high,
        components: []
    )
    
    static let mealWithHighCalories = Meal(
        timestamp: Date(),
        mealType: .dinner,
        name: "Double Bacon Cheeseburger",
        summary: "Large burger with bacon, cheese, and all the fixings",
        calories: 1250,
        protein: 55,
        carbs: 48,
        fat: 92,
        fiber: 3,
        saturatedFat: 38,
        sodium: 1850,
        healthScore: .poor,
        healthInsights: [
            "Very high in saturated fat",
            "Exceeds daily sodium recommendation",
            "Consider as occasional treat"
        ],
        allergens: [.dairy, .gluten, .eggs],
        dietaryTags: [.highProtein],
        confidence: .high,
        components: []
    )
    
    // MARK: - Daily Progress
    
    static let sampleDailyProgress = DailyProgress.from(
        meals: [sampleBreakfast, coffeeSnack, sampleLunch],
        goals: sampleDailyGoals
    )
    
    static let emptyDailyProgress = DailyProgress(
        goals: sampleDailyGoals
    )
    
    static let fullDayProgress = DailyProgress.from(
        meals: sampleMeals,
        goals: sampleDailyGoals
    )
    
    // MARK: - User Preferences
    
    static let sampleUserPreferences = UserPreferences(
        language: "en",
        region: "US",
        unitSystem: .metric,
        allergens: [.peanuts, .shellfish],
        dietaryPreferences: [.highProtein],
        avoidedIngredients: [],
        theme: .auto,
        enableHaptics: true,
        enableSounds: true,
        enableAnalytics: true,
        enableLocationTracking: false,
        enableiCloudSync: true
    )
    
    static let swedishUserPreferences = UserPreferences(
        language: "sv",
        region: "SE",
        unitSystem: .metric,
        allergens: [],
        dietaryPreferences: [],
        avoidedIngredients: [],
        theme: .auto,
        enableHaptics: true,
        enableSounds: false,
        enableAnalytics: false,
        enableLocationTracking: false,
        enableiCloudSync: true
    )
}

