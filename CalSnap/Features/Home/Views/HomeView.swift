//
//  HomeView.swift
//  CalSnap
//
//  Main dashboard showing daily progress and meals
//

import SwiftUI

struct HomeView: View {
    @Binding var navigationPath: NavigationPath
    @Binding var showSettings: Bool
    
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var calendarViewModel = WeekCalendarViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content
            ScrollView {
                VStack(spacing: 0) {
                    // Week Calendar
                    WeekCalendarView(viewModel: calendarViewModel) { selectedDate in
                        // Handle date selection - for now just update viewModel if needed
                        // In the future, this will load meals for the selected date
                    }
                    .padding(.top, AppTheme.Spacing.xs)
                    
                    // Daily Tracker Card
                    DailyTrackerCard(
                        caloriesConsumed: Int(viewModel.dailyProgress.caloriesConsumed),
                        calorieTarget: Int(viewModel.dailyProgress.goals.calorieTarget),
                        proteinConsumed: viewModel.dailyProgress.proteinConsumed,
                        proteinTarget: viewModel.dailyProgress.goals.proteinTarget,
                        carbsConsumed: viewModel.dailyProgress.carbsConsumed,
                        carbsTarget: viewModel.dailyProgress.goals.carbsTarget,
                        fatConsumed: viewModel.dailyProgress.fatConsumed,
                        fatTarget: viewModel.dailyProgress.goals.fatTarget
                    )
                    .padding(.horizontal, AppTheme.Spacing.md)
                    .padding(.top, AppTheme.Spacing.md)
                    
                    // Meals Section
                    if viewModel.hasMeals {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                            Text("Today's Meals")
                                .font(AppTheme.Typography.heading2)
                                .foregroundColor(AppTheme.Colors.textPrimary)
                                .padding(.horizontal, AppTheme.Spacing.md)
                            
                            ForEach(viewModel.meals) { meal in
                                Button {
                                    navigationPath.append(AppDestination.mealDetail(meal))
                                } label: {
                                    MealCard(
                                        title: meal.name,
                                        calories: Int(meal.totalCalories),
                                        protein: Int(meal.totalProtein),
                                        carbs: Int(meal.totalCarbs),
                                        fat: Int(meal.totalFat),
                                        time: meal.timeString,
                                        image: nil
                                    )
                                }
                                .buttonStyle(.plain)
                                .padding(.horizontal, AppTheme.Spacing.md)
                            }
                        }
                    } else {
                        // Empty state
                        VStack(spacing: AppTheme.Spacing.md) {
                            Image(systemName: "fork.knife")
                                .font(.system(size: 48))
                                .foregroundColor(AppTheme.Colors.textTertiary)
                            
                            Text("No meals logged today")
                                .font(AppTheme.Typography.heading3)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                            
                            Text("Add your first meal using the input below")
                                .font(AppTheme.Typography.bodyMedium)
                                .foregroundColor(AppTheme.Colors.textTertiary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.xl)
                    }
                }
                .padding(.bottom, 100) // Space for bottom bar
            }
            .background(AppTheme.Colors.background)
            
            // Bottom Input Bar
            BottomPromptBar(
                text: $viewModel.inputText,
                placeholder: "Add meal...",
                onCameraTap: { /* Camera action */ },
                onFavoritesTap: { /* Favorites action */ },
                onVoiceTap: { /* Voice action */ },
                onSendTap: {
                    viewModel.addDummyMeal()
                }
            )
        }
        .navigationTitle("CalSnap")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showSettings = true
                } label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 18))
                        .foregroundColor(AppTheme.Colors.textPrimary)
                }
            }
        }
    }
}

// MARK: - Previews

#Preview("Home - Populated") {
    NavigationStack {
        HomeView(
            navigationPath: .constant(NavigationPath()),
            showSettings: .constant(false)
        )
    }
}

// For preview purposes, we'll create separate preview variants
struct HomeViewEmpty: View {
    @StateObject private var viewModel = HomeViewModel()
    @Binding var navigationPath: NavigationPath
    @Binding var showSettings: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {
                    DailyTrackerCard(
                        caloriesConsumed: Int(viewModel.dailyProgress.caloriesConsumed),
                        calorieTarget: Int(viewModel.dailyProgress.goals.calorieTarget),
                        proteinConsumed: viewModel.dailyProgress.proteinConsumed,
                        proteinTarget: viewModel.dailyProgress.goals.proteinTarget,
                        carbsConsumed: viewModel.dailyProgress.carbsConsumed,
                        carbsTarget: viewModel.dailyProgress.goals.carbsTarget,
                        fatConsumed: viewModel.dailyProgress.fatConsumed,
                        fatTarget: viewModel.dailyProgress.goals.fatTarget
                    )
                    .padding(.horizontal, AppTheme.Spacing.md)
                    .padding(.top, AppTheme.Spacing.md)
                    
                    VStack(spacing: AppTheme.Spacing.md) {
                        Image(systemName: "fork.knife")
                            .font(.system(size: 48))
                            .foregroundColor(AppTheme.Colors.textTertiary)
                        
                        Text("No meals logged today")
                            .font(AppTheme.Typography.heading3)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                        
                        Text("Add your first meal using the input below")
                            .font(AppTheme.Typography.bodyMedium)
                            .foregroundColor(AppTheme.Colors.textTertiary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.xl)
                }
                .padding(.bottom, 100)
            }
            .background(AppTheme.Colors.background)
            
            BottomPromptBar(
                text: .constant(""),
                placeholder: "Add meal...",
                onCameraTap: {},
                onFavoritesTap: {},
                onVoiceTap: {},
                onSendTap: {}
            )
        }
        .navigationTitle("CalSnap")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { showSettings = true } label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 18))
                        .foregroundColor(AppTheme.Colors.textPrimary)
                }
            }
        }
        .onAppear {
            viewModel.clearMeals()
        }
    }
}

struct HomeViewManyMeals: View {
    @StateObject private var viewModel = HomeViewModel()
    @Binding var navigationPath: NavigationPath
    @Binding var showSettings: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {
                    DailyTrackerCard(
                        caloriesConsumed: Int(viewModel.dailyProgress.caloriesConsumed),
                        calorieTarget: Int(viewModel.dailyProgress.goals.calorieTarget),
                        proteinConsumed: viewModel.dailyProgress.proteinConsumed,
                        proteinTarget: viewModel.dailyProgress.goals.proteinTarget,
                        carbsConsumed: viewModel.dailyProgress.carbsConsumed,
                        carbsTarget: viewModel.dailyProgress.goals.carbsTarget,
                        fatConsumed: viewModel.dailyProgress.fatConsumed,
                        fatTarget: viewModel.dailyProgress.goals.fatTarget
                    )
                    .padding(.horizontal, AppTheme.Spacing.md)
                    .padding(.top, AppTheme.Spacing.md)
                    
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        Text("Today's Meals")
                            .font(AppTheme.Typography.heading2)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                            .padding(.horizontal, AppTheme.Spacing.md)
                        
                        ForEach(viewModel.meals) { meal in
                            Button {
                                navigationPath.append(AppDestination.mealDetail(meal))
                            } label: {
                                MealCard(
                                    title: meal.name,
                                    calories: Int(meal.totalCalories),
                                    protein: Int(meal.totalProtein),
                                    carbs: Int(meal.totalCarbs),
                                    fat: Int(meal.totalFat),
                                    time: meal.timeString,
                                    image: nil
                                )
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, AppTheme.Spacing.md)
                        }
                    }
                }
                .padding(.bottom, 100)
            }
            .background(AppTheme.Colors.background)
            
            BottomPromptBar(
                text: $viewModel.inputText,
                placeholder: "Add meal...",
                onCameraTap: {},
                onFavoritesTap: {},
                onVoiceTap: {},
                onSendTap: { viewModel.addDummyMeal() }
            )
        }
        .navigationTitle("CalSnap")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { showSettings = true } label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 18))
                        .foregroundColor(AppTheme.Colors.textPrimary)
                }
            }
        }
        .onAppear {
            viewModel.setManyMeals()
        }
    }
}

#Preview("Home - Empty Day") {
    NavigationStack {
        HomeViewEmpty(
            navigationPath: .constant(NavigationPath()),
            showSettings: .constant(false)
        )
    }
}

#Preview("Home - Many Meals (Scroll)") {
    NavigationStack {
        HomeViewManyMeals(
            navigationPath: .constant(NavigationPath()),
            showSettings: .constant(false)
        )
    }
}

#Preview("Home - Dark Mode") {
    NavigationStack {
        HomeView(
            navigationPath: .constant(NavigationPath()),
            showSettings: .constant(false)
        )
    }
    .preferredColorScheme(.dark)
}

#Preview("Home - Large Text") {
    NavigationStack {
        HomeView(
            navigationPath: .constant(NavigationPath()),
            showSettings: .constant(false)
        )
    }
    .environment(\.dynamicTypeSize, .accessibility2)
}
