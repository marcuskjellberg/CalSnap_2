//
//  MealDetailView.swift
//  CalSnap
//
//  Detailed view for viewing and editing a meal
//

import SwiftUI

struct MealDetailView: View {
    let meal: Meal
    
    @Environment(\.dismiss) private var dismiss
    @State private var portionMultiplier: Double = 1.0
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.lg) {
                // Meal Image Placeholder
                ZStack {
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg)
                        .fill(AppTheme.Colors.secondaryBackground)
                        .frame(height: 200)
                    
                    VStack(spacing: AppTheme.Spacing.sm) {
                        Image(systemName: "photo")
                            .font(.system(size: 48))
                            .foregroundColor(AppTheme.Colors.textTertiary)
                        
                        Text("No image")
                            .font(AppTheme.Typography.bodySmall)
                            .foregroundColor(AppTheme.Colors.textTertiary)
                    }
                }
                
                // Meal Info Card
                CardContainer {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        // Title and Type
                        HStack {
                            Text(meal.mealType.icon)
                                .font(.system(size: 24))
                            
                            VStack(alignment: .leading, spacing: AppTheme.Spacing.xxs) {
                                Text(meal.name)
                                    .font(AppTheme.Typography.heading2)
                                    .foregroundColor(AppTheme.Colors.textPrimary)
                                
                                Text("\(meal.mealType.displayName) • \(meal.timeString)")
                                    .font(AppTheme.Typography.bodySmall)
                                    .foregroundColor(AppTheme.Colors.textSecondary)
                            }
                            
                            Spacer()
                        }
                        
                        if let summary = meal.summary {
                            Text(summary)
                                .font(AppTheme.Typography.bodyMedium)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                        }
                        
                        Divider()
                        
                        // Nutrition Summary
                        HStack(spacing: AppTheme.Spacing.lg) {
                            NutrientDisplay(
                                label: "Calories",
                                value: "\(Int(meal.totalCalories * portionMultiplier))",
                                unit: "kcal",
                                color: AppTheme.Colors.calories
                            )
                            
                            Spacer()
                            
                            NutrientDisplay(
                                label: "Protein",
                                value: "\(Int(meal.totalProtein * portionMultiplier))",
                                unit: "g",
                                color: AppTheme.Colors.protein
                            )
                            
                            Spacer()
                            
                            NutrientDisplay(
                                label: "Carbs",
                                value: "\(Int(meal.totalCarbs * portionMultiplier))",
                                unit: "g",
                                color: AppTheme.Colors.carbs
                            )
                            
                            Spacer()
                            
                            NutrientDisplay(
                                label: "Fat",
                                value: "\(Int(meal.totalFat * portionMultiplier))",
                                unit: "g",
                                color: AppTheme.Colors.fat
                            )
                        }
                    }
                }
                
                // Portion Slider
                CardContainer {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text("Portion Size")
                            .font(AppTheme.Typography.heading3)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                        
                        QuantitySlider(
                            value: $portionMultiplier,
                            range: 0.25...2.0,
                            step: 0.25,
                            label: "Amount",
                            unit: "×"
                        )
                    }
                }
                
                // Components Section
                if !meal.components.isEmpty {
                    CardContainer {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                            Text("Ingredients")
                                .font(AppTheme.Typography.heading3)
                                .foregroundColor(AppTheme.Colors.textPrimary)
                            
                            ForEach(meal.components) { component in
                                ComponentRow(component: component)
                                
                                if component.id != meal.components.last?.id {
                                    Divider()
                                }
                            }
                        }
                    }
                }
                
                // Health Score Card
                if meal.healthScore != .unknown {
                    HealthScoreCard(
                        title: "Health Assessment",
                        description: meal.healthInsights.joined(separator: "\n"),
                        statusColor: meal.healthScore.color,
                        allergenWarning: meal.hasAllergenWarnings ? "Contains: \(meal.allergens.map { $0.displayName }.joined(separator: ", "))" : nil
                    )
                }
                
                // AI Confidence
                if meal.confidence != .high {
                    CardContainer(backgroundColor: meal.confidence.color.opacity(0.1)) {
                        HStack(spacing: AppTheme.Spacing.sm) {
                            Image(systemName: meal.confidence.icon)
                                .foregroundColor(meal.confidence.color)
                            
                            VStack(alignment: .leading, spacing: AppTheme.Spacing.xxs) {
                                Text(meal.confidence.displayName)
                                    .font(AppTheme.Typography.bodyMedium)
                                    .fontWeight(.semibold)
                                    .foregroundColor(AppTheme.Colors.textPrimary)
                                
                                if !meal.uncertaintyNotes.isEmpty {
                                    Text(meal.uncertaintyNotes.first ?? "")
                                        .font(AppTheme.Typography.bodySmall)
                                        .foregroundColor(AppTheme.Colors.textSecondary)
                                }
                            }
                            
                            Spacer()
                        }
                    }
                }
            }
            .padding(AppTheme.Spacing.md)
        }
        .background(AppTheme.Colors.background)
        .navigationTitle("Meal Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    dismiss()
                }
                .fontWeight(.semibold)
                .foregroundColor(AppTheme.Colors.primary)
            }
        }
    }
}

// MARK: - Supporting Views

private struct NutrientDisplay: View {
    let label: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.xxs) {
            Text(value)
                .font(AppTheme.Typography.numberMedium)
                .foregroundColor(color)
            
            Text(unit)
                .font(AppTheme.Typography.captionSmall)
                .foregroundColor(AppTheme.Colors.textTertiary)
            
            Text(label)
                .font(AppTheme.Typography.captionSmall)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
    }
}

private struct ComponentRow: View {
    let component: MealComponent
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xxs) {
                Text(component.name)
                    .font(AppTheme.Typography.bodyMedium)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                
                Text(component.quantityDisplay)
                    .font(AppTheme.Typography.captionLarge)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            
            Spacer()
            
            Text("\(Int(component.scaledCalories)) kcal")
                .font(AppTheme.Typography.numberSmall)
                .foregroundColor(AppTheme.Colors.calories)
        }
    }
}

// MARK: - Previews

#Preview("Meal Detail - Full") {
    NavigationStack {
        MealDetailView(meal: MockData.sampleBreakfast)
    }
}

#Preview("Meal Detail - Low Confidence") {
    NavigationStack {
        MealDetailView(meal: MockData.mealWithLowConfidence)
    }
}

#Preview("Meal Detail - Allergens") {
    NavigationStack {
        MealDetailView(meal: MockData.mealWithAllergens)
    }
}

#Preview("Meal Detail - Dark Mode") {
    NavigationStack {
        MealDetailView(meal: MockData.sampleLunch)
    }
    .preferredColorScheme(.dark)
}

#Preview("Meal Detail - Large Text") {
    NavigationStack {
        MealDetailView(meal: MockData.sampleBreakfast)
    }
    .environment(\.dynamicTypeSize, .accessibility1)
}

