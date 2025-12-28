import Foundation

/// Represents the user's daily nutrition targets
struct DailyGoals: Identifiable, Codable, Equatable {
    let id: UUID
    var lastUpdated: Date
    
    // Macro Targets
    var calorieTarget: Double
    var proteinTarget: Double
    var carbsTarget: Double
    var fatTarget: Double
    
    // Optional targets
    var fiberTarget: Double?
    var sugarLimit: Double?
    var sodiumLimit: Double?
    var saturatedFatLimit: Double?
    
    // Goal context
    var activityLevel: ActivityLevel?
    var goalType: GoalType?
    
    // User profile (optional, for recalculation)
    var age: Int?
    var height: Double?  // cm
    var weight: Double?  // kg
    
    // MARK: - Initializer
    
    init(
        id: UUID = UUID(),
        lastUpdated: Date = Date(),
        calorieTarget: Double,
        proteinTarget: Double,
        carbsTarget: Double,
        fatTarget: Double,
        fiberTarget: Double? = nil,
        sugarLimit: Double? = nil,
        sodiumLimit: Double? = nil,
        saturatedFatLimit: Double? = nil,
        activityLevel: ActivityLevel? = nil,
        goalType: GoalType? = nil,
        age: Int? = nil,
        height: Double? = nil,
        weight: Double? = nil
    ) {
        self.id = id
        self.lastUpdated = lastUpdated
        self.calorieTarget = calorieTarget
        self.proteinTarget = proteinTarget
        self.carbsTarget = carbsTarget
        self.fatTarget = fatTarget
        self.fiberTarget = fiberTarget
        self.sugarLimit = sugarLimit
        self.sodiumLimit = sodiumLimit
        self.saturatedFatLimit = saturatedFatLimit
        self.activityLevel = activityLevel
        self.goalType = goalType
        self.age = age
        self.height = height
        self.weight = weight
    }
}

