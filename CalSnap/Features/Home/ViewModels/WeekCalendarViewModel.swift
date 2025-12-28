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
    var objectWillChange: ObservableObjectPublisher = ObservableObjectPublisher()
    
    @Published var selectedDate: Date
    @Published var currentWeekStart: Date
    @Published var weekDays: [DayData] = []
    
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
        // Allow going forward up to today's week
        let calendar = Calendar.current
        let todayWeekStart = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
        return currentWeekStart < todayWeekStart || calendar.isDate(currentWeekStart, inSameDayAs: todayWeekStart)
    }
    
    // MARK: - Initializer
    
    init(selectedDate: Date = Date()) {
        self.selectedDate = selectedDate
        let calendar = Calendar.current
        self.currentWeekStart = calendar.dateInterval(of: .weekOfYear, for: selectedDate)?.start ?? selectedDate
        generateWeekDays()
    }
    
    // MARK: - Actions
    
    func previousWeek() {
        let calendar = Calendar.current
        currentWeekStart = calendar.date(byAdding: .weekOfYear, value: -1, to: currentWeekStart) ?? currentWeekStart
        generateWeekDays()
    }
    
    func nextWeek() {
        guard canGoNext else { return }
        let calendar = Calendar.current
        currentWeekStart = calendar.date(byAdding: .weekOfYear, value: 1, to: currentWeekStart) ?? currentWeekStart
        generateWeekDays()
    }
    
    func selectDate(_ date: Date) {
        selectedDate = date
        // If selected date is in a different week, update current week
        let calendar = Calendar.current
        if let weekStart = calendar.dateInterval(of: .weekOfYear, for: date)?.start,
           !calendar.isDate(weekStart, inSameDayAs: currentWeekStart) {
            currentWeekStart = weekStart
            generateWeekDays()
        }
    }
    
    // MARK: - Private Methods
    
    private func generateWeekDays() {
        let calendar = Calendar.current
        let today = Date()
        
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
            let isFuture = date > today
            
            // Mock data - generate realistic progress values
            let (status, completionPercentage, mealCount) = generateMockDayData(
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
    
    /// Generates mock day data for demonstration
    private func generateMockDayData(date: Date, isToday: Bool, isFuture: Bool) -> (DayStatus, Int, Int) {
        let calendar = Calendar.current
        let today = Date()
        
        if isFuture {
            // Future days have no data
            return (.future, 0, 0)
        }
        
        if isToday {
            // Today - check if we're in the afternoon (more likely to have data)
            let hour = calendar.component(.hour, from: today)
            if hour < 10 {
                // Morning - likely empty or partial
                return (.todayEmpty, 0, 0)
            } else {
                // Afternoon/evening - likely partial
                let mockPercentage = Int.random(in: 16...95)
                let mockMeals = mockPercentage > 20 ? Int.random(in: 1...3) : 0
                let status: DayStatus = mockMeals == 0 ? .todayEmpty : .todayPartial
                return (status, mockPercentage, mockMeals)
            }
        }
        
        // Past days - generate random but realistic data
        let daysAgo = calendar.dateComponents([.day], from: date, to: today).day ?? 0
        
        // Older days are more likely to be complete
        if daysAgo > 1 {
            let completionPercentage = Int.random(in: 70...120)
            let mealCount = Int.random(in: 2...5)
            return (.complete, completionPercentage, mealCount)
        } else {
            // Yesterday might be complete or partial
            let completionPercentage = Int.random(in: 16...112)
            let mealCount = completionPercentage > 20 ? Int.random(in: 1...4) : 0
            let status: DayStatus = completionPercentage > 80 ? .complete : .todayPartial
            return (status, completionPercentage, mealCount)
        }
    }
}


