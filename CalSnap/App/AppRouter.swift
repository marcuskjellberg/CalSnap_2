//
//  AppRouter.swift
//  CalSnap
//
//  Navigation coordinator for the app
//

import SwiftUI

/// Navigation destinations for the app
enum AppDestination: Hashable {
    case mealDetail(Meal)
    case editMeal(Meal)
}

/// Root view that handles navigation
struct AppRouter: View {
    @State private var navigationPath = NavigationPath()
    @State private var showSettings = false
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            HomeView(
                navigationPath: $navigationPath,
                showSettings: $showSettings
            )
            .navigationDestination(for: AppDestination.self) { destination in
                switch destination {
                case .mealDetail(let meal):
                    MealDetailView(meal: meal)
                case .editMeal(let meal):
                    // TODO: Create EditMealView
                    MealDetailView(meal: meal) // Placeholder - using detail view for now
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

// MARK: - Previews

#Preview("App Router") {
    AppRouter()
}

#Preview("Dark Mode") {
    AppRouter()
        .preferredColorScheme(.dark)
}

