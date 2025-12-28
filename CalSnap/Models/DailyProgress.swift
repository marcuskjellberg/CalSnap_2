import Foundation

/// Represents the user's progress for a specific day
struct DailyProgress: Identifiable, Codable, Equatable {
    let id: UUID
    var date: Date
    
    // Consumed totals
    var caloriesConsumed: Double
    var proteinConsumed: Double
    var carbsConsumed: Double
    var fatConsumed: Double
    var fiberConsumed: Double?
    
    // Meals logged
    var mealCount: Int
    var meals: [Meal]
    
    // Goals reference
    var goals: DailyGoals
    
    // MARK: - Computed Properties
    
    var calorieProgress: Double {
        guard goals.calorieTarget > 0 else { return 0 }
        return caloriesConsumed / goals.calorieTarget
    }
    
    var proteinProgress: Double {
        guard goals.proteinTarget > 0 else { return 0 }
        return proteinConsumed / goals.proteinTarget
    }
    
    var carbsProgress: Double {
        guard goals.carbsTarget > 0 else { return 0 }
        return carbsConsumed / goals.carbsTarget
    }
    
    var fatProgress: Double {
        guard goals.fatTarget > 0 else { return 0 }
        return fatConsumed / goals.fatTarget
    }
    
    var caloriesRemaining: Double {
        max(0, goals.calorieTarget - caloriesConsumed)
    }
    
    var proteinRemaining: Double {
        max(0, goals.proteinTarget - proteinConsumed)
    }
    
    var carbsRemaining: Double {
        max(0, goals.carbsTarget - carbsConsumed)
    }
    
    var fatRemaining: Double {
        max(0, goals.fatTarget - fatConsumed)
    }
    
    var isCalorieGoalMet: Bool {
        caloriesConsumed >= goals.calorieTarget * 0.9 &&
        caloriesConsumed <= goals.calorieTarget * 1.1
    }
    
    /// Formatted date string
    var dateString: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, MMM d"
            return formatter.string(from: date)
        }
    }
    
    // MARK: - Initializer
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        caloriesConsumed: Double = 0,
        proteinConsumed: Double = 0,
        carbsConsumed: Double = 0,
        fatConsumed: Double = 0,
        fiberConsumed: Double? = nil,
        mealCount: Int = 0,
        meals: [Meal] = [],
        goals: DailyGoals
    ) {
        self.id = id
        self.date = date
        self.caloriesConsumed = caloriesConsumed
        self.proteinConsumed = proteinConsumed
        self.carbsConsumed = carbsConsumed
        self.fatConsumed = fatConsumed
        self.fiberConsumed = fiberConsumed
        self.mealCount = mealCount
        self.meals = meals
        self.goals = goals
    }
    
    /// Create progress from a list of meals
    static func from(meals: [Meal], goals: DailyGoals, date: Date = Date()) -> DailyProgress {
        let calories = meals.reduce(0) { $0 + $1.totalCalories }
        let protein = meals.reduce(0) { $0 + $1.totalProtein }
        let carbs = meals.reduce(0) { $0 + $1.totalCarbs }
        let fat = meals.reduce(0) { $0 + $1.totalFat }
        let fiber = meals.compactMap { $0.totalFiber }.reduce(0, +)
        
        return DailyProgress(
            date: date,
            caloriesConsumed: calories,
            proteinConsumed: protein,
            carbsConsumed: carbs,
            fatConsumed: fat,
            fiberConsumed: fiber > 0 ? fiber : nil,
            mealCount: meals.count,
            meals: meals,
            goals: goals
        )
    }
}

