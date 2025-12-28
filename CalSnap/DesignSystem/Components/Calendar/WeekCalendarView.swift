//
//  WeekCalendarView.swift
//  CalSnap
//
//  Week calendar component showing 7 days with progress indicators
//

import SwiftUI

struct WeekCalendarView: View {
    @ObservedObject var viewModel: WeekCalendarViewModel
    var onDateSelected: ((Date) -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            // Week Navigation Bar
            HStack {
                Button(action: {
                    viewModel.previousWeek()
                    onDateSelected?(viewModel.selectedDate)
                    triggerHaptic(.light)
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.textPrimary)
                }
                .disabled(!viewModel.canGoPrevious)
                .opacity(viewModel.canGoPrevious ? 1.0 : 0.3)
                
                Spacer()
                
                Text(viewModel.monthYearLabel)
                    .font(AppTheme.Typography.captionLarge)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                
                Spacer()
                
                Button(action: {
                    viewModel.nextWeek()
                    onDateSelected?(viewModel.selectedDate)
                    triggerHaptic(.light)
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.textPrimary)
                }
                .disabled(!viewModel.canGoNext)
                .opacity(viewModel.canGoNext ? 1.0 : 0.3)
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.vertical, AppTheme.Spacing.sm)
            
            // Day Cells
            HStack(spacing: 4) {
                ForEach(viewModel.weekDays) { day in
                    DayCell(
                        day: day,
                        isSelected: Calendar.current.isDate(day.date, inSameDayAs: viewModel.selectedDate),
                        isToday: day.isToday
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            viewModel.selectDate(day.date)
                            onDateSelected?(day.date)
                        }
                        triggerHaptic(.light)
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.sm)
            .padding(.bottom, AppTheme.Spacing.sm)
        }
        .background(AppTheme.Colors.secondaryBackground)
        .gesture(
            DragGesture(minimumDistance: 50)
                .onEnded { value in
                    if value.translation.width > 50 {
                        // Swipe right - previous day
                        previousDay()
                    } else if value.translation.width < -50 {
                        // Swipe left - next day
                        nextDay()
                    }
                }
        )
    }
    
    // MARK: - Navigation Helpers
    
    private func previousDay() {
        let calendar = Calendar.current
        if let previousDate = calendar.date(byAdding: .day, value: -1, to: viewModel.selectedDate) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                viewModel.selectDate(previousDate)
                onDateSelected?(previousDate)
            }
            triggerHaptic(.light)
        }
    }
    
    private func nextDay() {
        let calendar = Calendar.current
        let today = Date()
        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: viewModel.selectedDate) else { return }
        
        // Allow navigation to today or any past day
        if calendar.isDate(nextDate, inSameDayAs: today) || nextDate < today {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                viewModel.selectDate(nextDate)
                onDateSelected?(nextDate)
            }
            triggerHaptic(.light)
        }
    }
    
    private func triggerHaptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

// MARK: - DayCell Component

struct DayCell: View {
    let day: DayData
    let isSelected: Bool
    let isToday: Bool
    
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 4) {
            // Day abbreviation
            Text(day.abbreviation)
                .font(AppTheme.Typography.captionSmall)
                .foregroundColor(textColor)
                .fontWeight(isSelected ? .semibold : .regular)
            
            // Date number
            Text("\(day.dayNumber)")
                .font(isSelected ? AppTheme.Typography.bodyMedium.weight(.bold) : AppTheme.Typography.bodySmall)
                .foregroundColor(textColor)
            
            // Progress indicator
            ProgressDot(status: day.status, progress: day.completionPercentage)
            
            // Percentage (only if has data)
            if day.hasData {
                Text("\(day.completionPercentage)%")
                    .font(AppTheme.Typography.captionTiny)
                    .foregroundColor(day.progressColor)
            } else if !day.status.isFuture {
                // Show empty indicator for today
                Text("0%")
                    .font(AppTheme.Typography.captionTiny)
                    .foregroundColor(AppTheme.Colors.textTertiary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppTheme.Spacing.xs)
        .background(backgroundColor)
        .cornerRadius(AppTheme.CornerRadius.sm)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.sm)
                .stroke(isToday ? AppTheme.Colors.primary : Color.clear, lineWidth: 2)
        )
        .scaleEffect(isSelected ? 1.0 : 0.95)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(day.accessibilityLabel)
        .accessibilityValue(day.accessibilityValue)
        .accessibilityHint(isSelected ? "Selected" : "Double tap to view this day")
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return AppTheme.Colors.primary.opacity(0.12)
        }
        return Color.clear
    }
    
    private var textColor: Color {
        if isSelected {
            return AppTheme.Colors.textPrimary
        }
        if isToday {
            return AppTheme.Colors.primary
        }
        return AppTheme.Colors.textSecondary
    }
}

// MARK: - ProgressDot Component

private struct ProgressDot: View {
    let status: DayStatus
    let progress: Int
    
    var body: some View {
        Text(status.icon)
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(status.color)
    }
}

extension DayStatus {
    var isFuture: Bool {
        if case .future = self {
            return true
        }
        return false
    }
}

// MARK: - Previews

#Preview("Week Calendar") {
    WeekCalendarView(viewModel: WeekCalendarViewModel())
        .padding()
        .background(AppTheme.Colors.background)
}

#Preview("Week Calendar - Dark Mode") {
    WeekCalendarView(viewModel: WeekCalendarViewModel())
        .padding()
        .background(AppTheme.Colors.background)
        .preferredColorScheme(.dark)
}

#Preview("Day Cell - Selected") {
    let calendar = Calendar.current
    let today = Date()
    let day = DayData(
        date: today,
        dayNumber: calendar.component(.day, from: today),
        abbreviation: "IDAG",
        fullName: "Idag",
        isToday: true,
        status: .todayPartial,
        completionPercentage: 85,
        mealCount: 2
    )
    
    DayCell(day: day, isSelected: true, isToday: true)
        .padding()
        .background(AppTheme.Colors.background)
}

#Preview("Day Cell - Today Unselected") {
    let calendar = Calendar.current
    let today = Date()
    let day = DayData(
        date: today,
        dayNumber: calendar.component(.day, from: today),
        abbreviation: "IDAG",
        fullName: "Idag",
        isToday: true,
        status: .todayPartial,
        completionPercentage: 85,
        mealCount: 2
    )
    
    DayCell(day: day, isSelected: false, isToday: true)
        .padding()
        .background(AppTheme.Colors.background)
}

#Preview("Day Cell - Complete") {
    let calendar = Calendar.current
    let date = calendar.date(byAdding: .day, value: -2, to: Date()) ?? Date()
    let day = DayData(
        date: date,
        dayNumber: calendar.component(.day, from: date),
        abbreviation: "MÅN",
        fullName: "Måndag",
        isToday: false,
        status: .complete,
        completionPercentage: 95,
        mealCount: 3
    )
    
    DayCell(day: day, isSelected: false, isToday: false)
        .padding()
        .background(AppTheme.Colors.background)
}

#Preview("Day Cell - Future") {
    let calendar = Calendar.current
    let date = calendar.date(byAdding: .day, value: 3, to: Date()) ?? Date()
    let day = DayData(
        date: date,
        dayNumber: calendar.component(.day, from: date),
        abbreviation: "FRE",
        fullName: "Fredag",
        isToday: false,
        status: .future,
        completionPercentage: 0,
        mealCount: 0
    )
    
    DayCell(day: day, isSelected: false, isToday: false)
        .padding()
        .background(AppTheme.Colors.background)
}

