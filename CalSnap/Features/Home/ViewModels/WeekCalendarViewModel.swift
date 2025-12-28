//
//  WeekCalendarViewModel.swift
//  CalSnap
//
//  ViewModel for week calendar component
//

import Foundation
import SwiftUI
import Combine

@MainActor
class WeekCalendarViewModel: ObservableObject {
    @Published var selectedDate: Date
    @Published var currentWeekStart: Date
    @Published var weekDays: [DayData] = []
    
    // MARK: - Private Properties
    
    private let calendar = Calendar.current
    private let goals = MockData.sampleDailyGoals
    
    // MARK: - Computed Properties
    
    var monthYearLabel: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "sv_SE")
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedDate).capitalized
    }
    
    var canGoPrevious: Bool {
        // For now, allow going back indefinitely (can add limits later)
        true
    }
    
    var canGoNext: Bool {
        // Prevent going into future weeks
        let today = Date()
        let todayWeekStart = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        // Can go next if current week is before today's week
        return currentWeekStart < todayWeekStart
    }
    
    // MARK: - Initializer
    
    init(selectedDate: Date = Date()) {
        let normalizedDate = calendar.startOfDay(for: selectedDate)
        self.selectedDate = normalizedDate
        if let weekStart = calendar.dateInterval(of: .weekOfYear, for: normalizedDate)?.start {
            self.currentWeekStart = calendar.startOfDay(for: weekStart)
        } else {
            self.currentWeekStart = normalizedDate
        }
        generateWeekDays()
    }
    
    // MARK: - Actions
    
    func previousWeek() {
        let calendar = Calendar.current
        let newWeekStart = calendar.date(byAdding: .weekOfYear, value: -1, to: currentWeekStart) ?? currentWeekStart
        currentWeekStart = calendar.startOfDay(for: newWeekStart)
        // Select first day of new week (normalized)
        selectedDate = currentWeekStart
        generateWeekDays()
    }
    
    func nextWeek() {
        guard canGoNext else { return }
        let calendar = Calendar.current
        let newWeekStart = calendar.date(byAdding: .weekOfYear, value: 1, to: currentWeekStart) ?? currentWeekStart
        let today = Date()
        let todayWeekStart = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        let normalizedNewWeekStart = calendar.startOfDay(for: newWeekStart)
        
        // Only allow going to today's week or earlier
        if normalizedNewWeekStart <= todayWeekStart {
            currentWeekStart = normalizedNewWeekStart
            // Select first day of new week, but don't go past today
            let firstDayOfWeek = currentWeekStart
            let todayStart = calendar.startOfDay(for: today)
            selectedDate = firstDayOfWeek > todayStart ? todayStart : firstDayOfWeek
            generateWeekDays()
        }
    }
    
    func selectDate(_ date: Date) {
        // Normalize to start of day
        let normalizedDate = calendar.startOfDay(for: date)
        let today = Date()
        
        // Don't allow selecting future dates
        if normalizedDate <= calendar.startOfDay(for: today) {
            selectedDate = normalizedDate
            // If selected date is in a different week, update current week
            if let weekStart = calendar.dateInterval(of: .weekOfYear, for: normalizedDate)?.start,
               !calendar.isDate(weekStart, inSameDayAs: currentWeekStart) {
                currentWeekStart = weekStart
                generateWeekDays()
            }
        }
    }
    
    // MARK: - Public Methods
    
    func generateWeekDays() {
        let today = Date()
        let mealsByDate = MockData.mealsByDate()
        
        var days: [DayData] = []
        
        // Generate 7 days starting from week start
        for dayOffset in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: currentWeekStart) else { continue }
            
            let dayNumber = calendar.component(.day, from: date)
            let weekday = calendar.component(.weekday, from: date)
            
            // Convert weekday (1=Sunday) to our array index (0=Monday)
            let weekIndex = (weekday + 5) % 7
            let abbreviation = DayData.swedishAbbreviations[weekIndex]
            let fullName = DayData.swedishFullNames[weekIndex]
            
            let isToday = calendar.isDate(date, inSameDayAs: today)
            let dayStart = calendar.startOfDay(for: date)
            let isFuture = date > today
            
            // Get actual meals for this date
            let dayMeals = mealsByDate[dayStart] ?? []
            
            // Calculate progress from actual meals
            let (status, completionPercentage, mealCount) = calculateDayProgress(
                meals: dayMeals,
                date: date,
                isToday: isToday,
                isFuture: isFuture
            )
            
            let dayData = DayData(
                date: date,
                dayNumber: dayNumber,
                abbreviation: abbreviation,
                fullName: fullName,
                isToday: isToday,
                status: status,
                completionPercentage: completionPercentage,
                mealCount: mealCount
            )
            
            days.append(dayData)
        }
        
        weekDays = days
    }
    
    /// Calculates day progress from actual meals data
    private func calculateDayProgress(meals: [Meal], date: Date, isToday: Bool, isFuture: Bool) -> (DayStatus, Int, Int) {
        if isFuture {
            // Future days have no data
            return (.future, 0, 0)
        }
        
        let mealCount = meals.count
        
        if mealCount == 0 {
            // No meals logged
            return (isToday ? .todayEmpty : .complete, 0, 0)
        }
        
        // Calculate total calories consumed
        let totalCalories = meals.reduce(0) { $0 + $1.totalCalories }
        let calorieTarget = goals.calorieTarget
        
        // Calculate completion percentage (can exceed 100%)
        let completionPercentage = Int((totalCalories / calorieTarget) * 100)
        
        // Determine status based on progress
        let status: DayStatus
        if isToday {
            // Today: use partial or empty based on progress
            if completionPercentage >= 80 {
                status = .complete
            } else if completionPercentage > 0 {
                status = .todayPartial
            } else {
                status = .todayEmpty
            }
        } else {
            // Past days: always complete (even if 0%)
            status = .complete
        }
        
        return (status, completionPercentage, mealCount)
    }
}


