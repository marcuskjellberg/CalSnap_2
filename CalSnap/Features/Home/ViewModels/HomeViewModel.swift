//
//  HomeViewModel.swift
//  CalSnap
//
//  ViewModel for HomeView - manages daily progress and meals
//

import Foundation
import SwiftUI
import Combine

/// ViewModel for the Home screen
@MainActor
class HomeViewModel: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    
    // MARK: - Published Properties
    
    @Published var meals: [Meal] = MockData.sampleMeals
    @Published var dailyProgress: DailyProgress = MockData.sampleDailyProgress
    @Published var inputText: String = ""
    
    // MARK: - Computed Properties
    
    var hasMeals: Bool {
        !meals.isEmpty
    }
    
    var mealCount: Int {
        meals.count
    }
    
    // MARK: - Initializer
    
    init() {
        // Initialize with mock data
        updateDailyProgress()
    }
    
    // MARK: - Actions
    
    /// Adds a dummy meal when user taps send (for UI testing)
    func addDummyMeal() {
        let dummyMeal = Meal(
            timestamp: Date(),
            mealType: .snack,
            name: "New Meal",
            summary: "Dummy meal added for testing",
            calories: 350,
            protein: 20,
            carbs: 40,
            fat: 12,
            fiber: 5,
            healthScore: .good,
            healthInsights: ["Test meal"],
            allergens: [],
            dietaryTags: [],
            confidence: .medium,
            uncertaintyNotes: [],
            components: []
        )
        
        meals.append(dummyMeal)
        updateDailyProgress()
        inputText = ""
    }
    
    /// Updates daily progress based on current meals
    private func updateDailyProgress() {
        dailyProgress = DailyProgress.from(
            meals: meals,
            goals: dailyProgress.goals,
            date: dailyProgress.date
        )
    }
    
    /// Clears all meals (for testing empty state)
    func clearMeals() {
        meals = []
        updateDailyProgress()
    }
    
    /// Sets meals to a large collection (for testing scroll)
    func setManyMeals() {
        var manyMeals: [Meal] = []
        
        // Add meals throughout the day
        let mealTypes: [MealType] = [.breakfast, .lunch, .snack, .dinner, .snack]
        let mealNames = [
            "Greek Yogurt Bowl",
            "Salmon Salad",
            "Protein Shake",
            "Chicken Stir-Fry",
            "Apple with Almond Butter",
            "Coffee with Milk",
            "Turkey Sandwich",
            "Mixed Nuts",
            "Grilled Chicken",
            "Green Smoothie",
            "Oatmeal",
            "Rice Bowl"
        ]
        
        let calendar = Calendar.current
        var hour = 7
        
        for (index, mealName) in mealNames.enumerated() {
            if hour >= 22 { hour = 7 } // Reset to morning after late night
            
            let date = calendar.date(bySettingHour: hour, minute: index % 60, second: 0, of: Date()) ?? Date()
            let mealType = mealTypes[index % mealTypes.count]
            
            let meal = Meal(
                timestamp: date,
                mealType: mealType,
                name: mealName,
                calories: Double(300 + index * 50),
                protein: Double(20 + index * 5),
                carbs: Double(30 + index * 8),
                fat: Double(10 + index * 2),
                healthScore: .good,
                healthInsights: [],
                allergens: [],
                dietaryTags: [],
                confidence: .high,
                components: []
            )
            
            manyMeals.append(meal)
            hour += 2
        }
        
        meals = manyMeals
        updateDailyProgress()
    }
}

