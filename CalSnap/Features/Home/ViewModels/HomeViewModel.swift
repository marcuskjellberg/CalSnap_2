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
    // MARK: - Published Properties
    
    @Published var selectedDate: Date = Date() {
        didSet {
            loadMealsForSelectedDate()
        }
    }
    
    @Published var meals: [Meal] = []
    @Published var dailyProgress: DailyProgress = MockData.sampleDailyProgress
    @Published var inputText: String = ""
    
    // MARK: - Private Properties
    
    private let calendar = Calendar.current
    
    // MARK: - Computed Properties
    
    var hasMeals: Bool {
        !meals.isEmpty
    }
    
    var mealCount: Int {
        meals.count
    }
    
    // MARK: - Initializer
    
    init() {
        // Initialize with today's meals
        loadMealsForSelectedDate()
    }
    
    // MARK: - Actions
    
    /// Loads meals for the currently selected date
    func loadMealsForSelectedDate() {
        meals = MockData.meals(for: selectedDate)
        updateDailyProgress()
    }
    
    /// Updates the selected date and loads meals for that date
    func selectDate(_ date: Date) {
        // Normalize to start of day to ensure consistency
        let normalizedDate = calendar.startOfDay(for: date)
        // Assign to trigger didSet which will call loadMealsForSelectedDate()
        selectedDate = normalizedDate
    }
    
    /// Adds a dummy meal when user taps send (for UI testing)
    /// Note: This adds to today's date only
    func addDummyMeal() {
        let calendar = Calendar.current
        let isToday = calendar.isDate(selectedDate, inSameDayAs: Date())
        
        // Only allow adding meals to today
        guard isToday else { return }
        
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
        meals.sort { $0.timestamp < $1.timestamp }
        updateDailyProgress()
        inputText = ""
    }
    
    /// Updates daily progress based on current meals
    private func updateDailyProgress() {
        dailyProgress = DailyProgress.from(
            meals: meals,
            goals: dailyProgress.goals,
            date: selectedDate
        )
    }
    
    /// Clears all meals (for testing empty state)
    /// Note: This only clears today's meals
    func clearMeals() {
        let isToday = calendar.isDate(selectedDate, inSameDayAs: Date())
        if isToday {
            meals = []
            updateDailyProgress()
        }
    }
    
    /// Sets meals to a large collection (for testing scroll)
    /// Note: This only works for today
    func setManyMeals() {
        let isToday = calendar.isDate(selectedDate, inSameDayAs: Date())
        guard isToday else { return }
        
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

