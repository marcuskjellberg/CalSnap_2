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
    @State private var showCamera = false
    @State private var selectedImages: [UIImage] = []
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content (tappable to dismiss keyboard)
            ScrollView {
                VStack(spacing: 0) {
                    // Custom Navigation Header with Icon
                    HStack(spacing: 10) {
                        MacroIcon(iconName: "Calories", tint: AppTheme.Colors.calories, size: 32)
                        
                        Text("CalSnap")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(AppTheme.Colors.textPrimary)
                        
                        Spacer()
                        
                        // Profile Button
                        Button {
                            showSettings = true
                        } label: {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(AppTheme.Colors.textPrimary)
                        }
                        .accessibilityLabel("Profile")
                        .accessibilityHint("View your profile and settings")
                    }
                    .padding(.horizontal, AppTheme.Spacing.md)
                    .padding(.top, AppTheme.Spacing.md)
                    .padding(.bottom, AppTheme.Spacing.xs)
                    .background(AppTheme.Colors.background)
                    
                    // Week Calendar
                    WeekCalendarView(viewModel: calendarViewModel) { selectedDate in
                        // Update HomeViewModel when date is selected
                        // Note: calendarViewModel.selectDate is already called in WeekCalendarView
                        viewModel.selectDate(selectedDate)
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
                        fatTarget: viewModel.dailyProgress.goals.fatTarget,
                        mealCount: viewModel.mealCount,
                        selectedDate: viewModel.selectedDate
                    )
                    .padding(.horizontal, AppTheme.Spacing.md)
                    .padding(.top, AppTheme.Spacing.md)
                    
                    Spacer(minLength: AppTheme.Spacing.md)
                    
                    // Meals Section
                    if viewModel.hasMeals {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            Text(mealsSectionTitle)
                                .font(AppTheme.Typography.heading2)
                                .foregroundColor(AppTheme.Colors.textPrimary)
                                .padding(.horizontal, AppTheme.Spacing.md)
                            
                            ForEach(viewModel.meals) { meal in
                                SwipeableCard(
                                    actions: [
                                        .add { 
                                            viewModel.duplicateMeal(meal)
                                        },
                                        .favorite(isFavorite: meal.isFavorite) { 
                                            viewModel.toggleFavorite(meal)
                                        },
                                        .delete { 
                                            viewModel.deleteMeal(meal)
                                        }
                                    ]
                                ) {
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
                                .padding(.horizontal, AppTheme.Spacing.md)
                            }
                        }
                    } else {
                        // Empty state
                        VStack(spacing: AppTheme.Spacing.md) {
                            Image(systemName: "fork.knife")
                                .font(.system(size: 48))
                                .foregroundColor(AppTheme.Colors.textTertiary)
                            
                            Text(emptyStateTitle)
                                .font(AppTheme.Typography.heading3)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                            
                            Text(emptyStateMessage)
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
            .contentShape(Rectangle())
            .simultaneousGesture(
                TapGesture().onEnded { _ in
                    // Dismiss keyboard when tapping on scroll view content
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            )
            
            // Bottom Input Bar (always visible)
            BottomPromptBar(
                text: $viewModel.inputText,
                placeholder: "Ask anything",
                selectedImages: $selectedImages,
                onCameraTap: { 
                    showCamera = true
                },
                onFavoritesTap: { /* Favorites action */ },
                onSendTap: {
                    viewModel.addDummyMeal()
                }
            )
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showCamera) {
            CameraPickerView { images in
                selectedImages = images
            }
        }
        .onAppear {
            // Sync initial selected date
            viewModel.selectDate(calendarViewModel.selectedDate)
        }
    }
    
    // MARK: - Computed Properties
    
    private var mealsSectionTitle: String {
        let calendar = Calendar.current
        if calendar.isDate(viewModel.selectedDate, inSameDayAs: Date()) {
            return "Today's Meals"
        } else if calendar.isDateInYesterday(viewModel.selectedDate) {
            return "Yesterday's Meals"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, MMM d"
            return formatter.string(from: viewModel.selectedDate) + "'s Meals"
        }
    }
    
    private var emptyStateTitle: String {
        let calendar = Calendar.current
        if calendar.isDate(viewModel.selectedDate, inSameDayAs: Date()) {
            return "No meals logged today"
        } else if calendar.isDateInYesterday(viewModel.selectedDate) {
            return "No meals logged yesterday"
        } else {
            return "No meals logged"
        }
    }
    
    private var emptyStateMessage: String {
        let calendar = Calendar.current
        if calendar.isDate(viewModel.selectedDate, inSameDayAs: Date()) {
            return "Add your first meal using the input below"
        } else {
            return "No meals were logged on this day"
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
                placeholder: "Ask anything",
                selectedImages: .constant([]),
                onCameraTap: {},
                onFavoritesTap: {},
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
                            SwipeableCard(
                                actions: [
                                    .add { viewModel.addDummyMeal() },
                                    .edit { },
                                    .delete { }
                                ]
                            ) {
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
                            .padding(.horizontal, AppTheme.Spacing.md)
                        }
                    }
                }
                .padding(.bottom, 100)
            }
            .background(AppTheme.Colors.background)
            
            BottomPromptBar(
                text: $viewModel.inputText,
                placeholder: "Ask anything",
                selectedImages: .constant([]),
                onCameraTap: {},
                onFavoritesTap: {},
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

