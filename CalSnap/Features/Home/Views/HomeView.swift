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
    
    @State private var inputText = ""
    
    // Mock data for UI development
    private let dailyProgress = MockData.sampleDailyProgress
    private let meals = MockData.sampleMeals
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {
                    // Daily Tracker Card
                    DailyTrackerCard(
                        caloriesConsumed: Int(dailyProgress.caloriesConsumed),
                        calorieTarget: Int(dailyProgress.goals.calorieTarget),
                        proteinConsumed: dailyProgress.proteinConsumed,
                        proteinTarget: dailyProgress.goals.proteinTarget,
                        carbsConsumed: dailyProgress.carbsConsumed,
                        carbsTarget: dailyProgress.goals.carbsTarget,
                        fatConsumed: dailyProgress.fatConsumed,
                        fatTarget: dailyProgress.goals.fatTarget
                    )
                    
                    // Meals Section
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        Text("Today's Meals")
                            .font(AppTheme.Typography.heading2)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                            .padding(.horizontal, AppTheme.Spacing.md)
                        
                        ForEach(meals) { meal in
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
                        }
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.top, AppTheme.Spacing.md)
                .padding(.bottom, 100) // Space for bottom bar
            }
            .background(AppTheme.Colors.background)
            
            // Bottom Input Bar
            BottomPromptBar(
                text: $inputText,
                placeholder: "Add meal...",
                onCameraTap: { /* Camera action */ },
                onFavoritesTap: { /* Favorites action */ },
                onVoiceTap: { /* Voice action */ },
                onSendTap: { /* Send action */ }
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
    .environment(\.dynamicTypeSize, .accessibility1)
}
