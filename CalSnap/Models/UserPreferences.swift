import Foundation

/// User preferences and settings
struct UserPreferences: Identifiable, Codable, Equatable {
    let id: UUID
    
    // Localization
    var language: String        // "en", "sv", "de"
    var region: String          // "US", "SE", "DE"
    var unitSystem: UnitSystem
    
    // Dietary Restrictions
    var allergens: [Allergen]
    var dietaryPreferences: [DietaryTag]
    var avoidedIngredients: [String]
    
    // App Preferences
    var theme: ThemeMode
    var defaultMealType: MealType?
    var enableHaptics: Bool
    var enableSounds: Bool
    
    // Privacy
    var enableAnalytics: Bool
    var enableLocationTracking: Bool
    var enableiCloudSync: Bool
    
    // MARK: - Initializer
    
    init(
        id: UUID = UUID(),
        language: String = "en",
        region: String = "US",
        unitSystem: UnitSystem = .metric,
        allergens: [Allergen] = [],
        dietaryPreferences: [DietaryTag] = [],
        avoidedIngredients: [String] = [],
        theme: ThemeMode = .auto,
        defaultMealType: MealType? = nil,
        enableHaptics: Bool = true,
        enableSounds: Bool = true,
        enableAnalytics: Bool = true,
        enableLocationTracking: Bool = false,
        enableiCloudSync: Bool = true
    ) {
        self.id = id
        self.language = language
        self.region = region
        self.unitSystem = unitSystem
        self.allergens = allergens
        self.dietaryPreferences = dietaryPreferences
        self.avoidedIngredients = avoidedIngredients
        self.theme = theme
        self.defaultMealType = defaultMealType
        self.enableHaptics = enableHaptics
        self.enableSounds = enableSounds
        self.enableAnalytics = enableAnalytics
        self.enableLocationTracking = enableLocationTracking
        self.enableiCloudSync = enableiCloudSync
    }
    
    // MARK: - Default
    
    static let `default` = UserPreferences()
}

