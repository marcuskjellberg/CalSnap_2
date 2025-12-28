import Foundation

/// Represents a complete meal with nutrition data and components
struct Meal: Identifiable, Codable, Equatable, Hashable {
    
    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: UUID
    var timestamp: Date
    var mealType: MealType
    
    // Basic Info
    var name: String
    var summary: String?
    var imageData: Data?
    var thumbnailData: Data?
    
    // Nutrition (canonical units - grams/milligrams)
    var calories: Double
    var protein: Double          // g
    var carbs: Double            // g
    var fat: Double              // g
    var fiber: Double?           // g
    var sugar: Double?           // g
    var saturatedFat: Double?    // g
    var sodium: Double?          // mg
    
    // Portion
    var portionMultiplier: Double = 1.0  // 1.0 = 100%
    var totalWeight: Double?             // grams
    var familiarUnit: String?            // "1 bowl", "2 cups"
    
    // Health Assessment
    var healthScore: HealthLevel
    var healthInsights: [String]
    
    // Allergens & Dietary
    var allergens: [Allergen]
    var dietaryTags: [DietaryTag]
    
    // AI Metadata
    var confidence: ConfidenceLevel
    var uncertaintyNotes: [String]
    
    // Components
    var components: [MealComponent]
    
    // MARK: - Computed Properties
    
    var totalCalories: Double {
        calories * portionMultiplier
    }
    
    var totalProtein: Double {
        protein * portionMultiplier
    }
    
    var totalCarbs: Double {
        carbs * portionMultiplier
    }
    
    var totalFat: Double {
        fat * portionMultiplier
    }
    
    var totalFiber: Double? {
        guard let fiber = fiber else { return nil }
        return fiber * portionMultiplier
    }
    
    var hasAllergenWarnings: Bool {
        !allergens.isEmpty
    }
    
    /// Formatted time string (e.g., "9:37 AM")
    var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
    
    /// Formatted date string (e.g., "Today" or "Dec 28")
    var dateString: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(timestamp) {
            return "Today"
        } else if calendar.isDateInYesterday(timestamp) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return formatter.string(from: timestamp)
        }
    }
    
    // MARK: - Initializer
    
    init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        mealType: MealType,
        name: String,
        summary: String? = nil,
        imageData: Data? = nil,
        thumbnailData: Data? = nil,
        calories: Double,
        protein: Double,
        carbs: Double,
        fat: Double,
        fiber: Double? = nil,
        sugar: Double? = nil,
        saturatedFat: Double? = nil,
        sodium: Double? = nil,
        portionMultiplier: Double = 1.0,
        totalWeight: Double? = nil,
        familiarUnit: String? = nil,
        healthScore: HealthLevel = .unknown,
        healthInsights: [String] = [],
        allergens: [Allergen] = [],
        dietaryTags: [DietaryTag] = [],
        confidence: ConfidenceLevel = .high,
        uncertaintyNotes: [String] = [],
        components: [MealComponent] = []
    ) {
        self.id = id
        self.timestamp = timestamp
        self.mealType = mealType
        self.name = name
        self.summary = summary
        self.imageData = imageData
        self.thumbnailData = thumbnailData
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
        self.fiber = fiber
        self.sugar = sugar
        self.saturatedFat = saturatedFat
        self.sodium = sodium
        self.portionMultiplier = portionMultiplier
        self.totalWeight = totalWeight
        self.familiarUnit = familiarUnit
        self.healthScore = healthScore
        self.healthInsights = healthInsights
        self.allergens = allergens
        self.dietaryTags = dietaryTags
        self.confidence = confidence
        self.uncertaintyNotes = uncertaintyNotes
        self.components = components
    }
}

