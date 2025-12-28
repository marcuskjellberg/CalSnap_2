import Foundation

/// Represents an individual food item within a meal
struct MealComponent: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var order: Int
    
    // Quantity (canonical units)
    var quantity: Double        // grams or milliliters
    var unit: CanonicalUnit     // .grams or .milliliters
    
    // Familiar representation
    var familiarQuantity: Double?
    var familiarUnit: String?   // "cup", "egg", "piece", "tablespoon"
    
    // Nutrition (per declared quantity)
    var calories: Double
    var protein: Double
    var carbs: Double
    var fat: Double
    var fiber: Double?
    var sugar: Double?
    var saturatedFat: Double?
    var sodium: Double?
    
    // Component metadata
    var foodCategory: FoodCategory?
    var isLiquid: Bool
    var allergens: [Allergen]
    var dietaryTags: [DietaryTag]
    
    // AI metadata
    var confidence: ConfidenceLevel
    var uncertaintyNote: String?
    
    // Portion control
    var isLocked: Bool = false  // Exclude from global portion scaling
    var customMultiplier: Double = 1.0
    
    // MARK: - Computed Properties
    
    var scaledCalories: Double {
        calories * customMultiplier
    }
    
    var scaledProtein: Double {
        protein * customMultiplier
    }
    
    var scaledCarbs: Double {
        carbs * customMultiplier
    }
    
    var scaledFat: Double {
        fat * customMultiplier
    }
    
    /// Display string for quantity (e.g., "1 cup" or "150g")
    var quantityDisplay: String {
        if let familiarQty = familiarQuantity, let familiarU = familiarUnit {
            return "\(Int(familiarQty)) \(familiarU)"
        }
        return "\(Int(quantity))\(unit.abbreviation)"
    }
    
    // MARK: - Initializer
    
    init(
        id: UUID = UUID(),
        name: String,
        order: Int = 0,
        quantity: Double,
        unit: CanonicalUnit = .grams,
        familiarQuantity: Double? = nil,
        familiarUnit: String? = nil,
        calories: Double,
        protein: Double,
        carbs: Double,
        fat: Double,
        fiber: Double? = nil,
        sugar: Double? = nil,
        saturatedFat: Double? = nil,
        sodium: Double? = nil,
        foodCategory: FoodCategory? = nil,
        isLiquid: Bool = false,
        allergens: [Allergen] = [],
        dietaryTags: [DietaryTag] = [],
        confidence: ConfidenceLevel = .high,
        uncertaintyNote: String? = nil,
        isLocked: Bool = false,
        customMultiplier: Double = 1.0
    ) {
        self.id = id
        self.name = name
        self.order = order
        self.quantity = quantity
        self.unit = unit
        self.familiarQuantity = familiarQuantity
        self.familiarUnit = familiarUnit
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
        self.fiber = fiber
        self.sugar = sugar
        self.saturatedFat = saturatedFat
        self.sodium = sodium
        self.foodCategory = foodCategory
        self.isLiquid = isLiquid
        self.allergens = allergens
        self.dietaryTags = dietaryTags
        self.confidence = confidence
        self.uncertaintyNote = uncertaintyNote
        self.isLocked = isLocked
        self.customMultiplier = customMultiplier
    }
}

