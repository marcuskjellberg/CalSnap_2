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
    @State private var componentMultipliers: [UUID: Double] = [:]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(spacing: 0) {
                        // Hero Image Section
                        HeroImageSection(meal: scaledMeal)
                            .frame(height: geometry.size.width * 9 / 16) // 16:9 aspect ratio
                        
                        // Nutrition Summary Pills
                        NutritionSummarySection(meal: scaledMeal)
                            .padding(.horizontal, AppTheme.Spacing.md)
                            .padding(.vertical, AppTheme.Spacing.lg)
                        
                        // Details Section
                        VStack(spacing: AppTheme.Spacing.lg) {
                            // Meal Name and Time
                            MealInfoSection(meal: meal)
                            
                            // Portion Control
                            PortionControlSection(
                                meal: meal,
                                portionMultiplier: $portionMultiplier,
                                totalWeight: scaledMeal.totalWeight ?? 0
                            )
                            
                            // Health Insights Card
                            if !meal.healthInsights.isEmpty || meal.hasAllergenWarnings {
                                HealthInsightsCard(meal: scaledMeal)
                            }
                            
                            // Components List
                            if !meal.components.isEmpty {
                                ComponentsListSection(
                                    meal: meal,
                                    componentMultipliers: $componentMultipliers
                                )
                            }
                        }
                        .padding(.horizontal, AppTheme.Spacing.md)
                        .padding(.bottom, AppTheme.Spacing.xl)
                    }
                }
                
                // Navigation Overlay (Back + Delete buttons)
                NavigationOverlay(onDelete: { dismiss() })
            }
        }
        .background(AppTheme.Colors.background)
        .navigationBarHidden(true)
        .onAppear {
            // Initialize component multipliers
            for component in meal.components {
                componentMultipliers[component.id] = 1.0
            }
        }
    }
    
    // Computed meal with scaling applied
    private var scaledMeal: Meal {
        var scaled = meal
        scaled.portionMultiplier = portionMultiplier
        
        // Apply component multipliers
        var scaledComponents: [MealComponent] = []
        var totalCalories: Double = 0
        var totalProtein: Double = 0
        var totalCarbs: Double = 0
        var totalFat: Double = 0
        
        for component in meal.components {
            let multiplier = componentMultipliers[component.id] ?? 1.0
            var scaledComponent = component
            scaledComponent.customMultiplier = multiplier
            
            totalCalories += component.calories * multiplier
            totalProtein += component.protein * multiplier
            totalCarbs += component.carbs * multiplier
            totalFat += component.fat * multiplier
            
            scaledComponents.append(scaledComponent)
        }
        
        if !scaledComponents.isEmpty {
            scaled.calories = totalCalories
            scaled.protein = totalProtein
            scaled.carbs = totalCarbs
            scaled.fat = totalFat
        }
        
        scaled.components = scaledComponents
        return scaled
    }
}

// MARK: - Hero Image Section

private struct HeroImageSection: View {
    let meal: Meal
    
    var body: some View {
        ZStack {
            // Background image or placeholder
            if let imageData = meal.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .clipped()
            } else {
                // Placeholder with fork.knife icon
                ZStack {
                    AppTheme.Colors.secondary
                    
                    VStack(spacing: AppTheme.Spacing.sm) {
                        Image(systemName: "fork.knife")
                            .font(.system(size: 64))
                            .foregroundColor(AppTheme.Colors.textTertiary)
                    }
                }
            }
        }
    }
}

// MARK: - Navigation Overlay

private struct NavigationOverlay: View {
    let onDelete: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            HStack {
                // Back button
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(.ultraThinMaterial, in: Circle())
                }
                
                Spacer()
                
                // Delete button
                Button {
                    onDelete()
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(.ultraThinMaterial, in: Circle())
                }
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.top, AppTheme.Spacing.md)
            
            Spacer()
        }
    }
}

// MARK: - Nutrition Summary Section

private struct NutritionSummarySection: View {
    let meal: Meal
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            // Large Calorie Display
            HStack {
                MacroIcon(iconName: "Calories", tint: AppTheme.Colors.calories, size: 40)
                Text("\(Int(meal.totalCalories))")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(AppTheme.Colors.textPrimary)
                Text("kcal")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            
            // Macro Pills
            HStack(spacing: AppTheme.Spacing.lg) {
                MacroPill(
                    label: "PROTEIN",
                    value: "\(Int(meal.totalProtein))g",
                    color: AppTheme.Colors.protein,
                    iconName: "Protein"
                )
                
                MacroPill(
                    label: "KOLHYDRATER",
                    value: "\(Int(meal.totalCarbs))g",
                    color: AppTheme.Colors.carbs,
                    iconName: "Carbs"
                )
                
                MacroPill(
                    label: "FETT",
                    value: "\(Int(meal.totalFat))g",
                    color: AppTheme.Colors.fat,
                    iconName: "Fat"
                )
            }
        }
    }
}

// MARK: - Meal Info Section

private struct MealInfoSection: View {
    let meal: Meal
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            // Meal Name (editable)
            HStack {
                Text(meal.name)
                    .font(AppTheme.Typography.heading2)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                
                Image(systemName: "pencil")
                    .font(.system(size: 16))
                    .foregroundColor(AppTheme.Colors.textTertiary)
            }
            
            // Time and Date
            HStack {
                Text(meal.timeString)
                    .font(AppTheme.Typography.bodySmall)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                
                Image(systemName: "pencil")
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.Colors.textTertiary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Portion Control Section

private struct PortionControlSection: View {
    let meal: Meal
    @Binding var portionMultiplier: Double
    let totalWeight: Double
    
    private var scaledWeight: Double {
        totalWeight * portionMultiplier
    }
    
    var body: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text("TOTAL PORTION")
                    .font(AppTheme.Typography.captionLarge)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                
                Text("\(Int(scaledWeight)) G")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppTheme.Colors.textPrimary)
                
                QuantitySlider(
                    value: $portionMultiplier,
                    range: 0.5...2.0,
                    step: 0.05,
                    label: "",
                    unit: ""
                )
            }
        }
    }
}

// MARK: - Health Insights Card

private struct HealthInsightsCard: View {
    let meal: Meal
    
    var body: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                // Header
                HStack(spacing: AppTheme.Spacing.xs) {
                    Text("🔍")
                        .font(.system(size: 18))
                    Text("INSIKTER")
                        .font(AppTheme.Typography.heading3)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                }
                
                // Insights text
                if !meal.healthInsights.isEmpty {
                    Text(meal.healthInsights.joined(separator: "\n"))
                        .font(AppTheme.Typography.bodySmall)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                        .lineSpacing(4)
                }
                
                // Allergen warnings
                if meal.hasAllergenWarnings {
                    ForEach(meal.allergens, id: \.self) { allergen in
                        HStack(spacing: AppTheme.Spacing.xs) {
                            Text("⚠️")
                                .font(.system(size: 16))
                            Text(allergen.displayName)
                                .font(AppTheme.Typography.captionLarge)
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.Colors.statusError)
                        }
                        .padding(.vertical, AppTheme.Spacing.xs)
                        .padding(.horizontal, AppTheme.Spacing.sm)
                        .background(AppTheme.Colors.statusError.opacity(0.1))
                        .cornerRadius(AppTheme.CornerRadius.sm)
                    }
                }
                
                // Disclaimer
                Text("AI-uppskattning. Ej medicinskt råd.")
                    .font(AppTheme.Typography.captionTiny)
                    .foregroundColor(AppTheme.Colors.textTertiary)
                    .padding(.top, AppTheme.Spacing.xs)
            }
        }
    }
    
   
}

// MARK: - Components List Section

private struct ComponentsListSection: View {
    let meal: Meal
    @Binding var componentMultipliers: [UUID: Double]
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            // Header
            HStack {
                Text("Innehåll")
                    .font(AppTheme.Typography.heading3)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                
                Spacer()
                
                Text("\(meal.components.count) TOTALT")
                    .font(AppTheme.Typography.captionLarge)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .padding(.horizontal, AppTheme.Spacing.sm)
                    .padding(.vertical, AppTheme.Spacing.xxs)
                    .background(AppTheme.Colors.secondary.opacity(0.3))
                    .cornerRadius(AppTheme.CornerRadius.sm)
            }
            
            // Component cards
            VStack(spacing: AppTheme.Spacing.md) {
                ForEach(meal.components) { component in
                    ComponentCard(
                        component: component,
                        multiplier: Binding(
                            get: { componentMultipliers[component.id] ?? 1.0 },
                            set: { componentMultipliers[component.id] = $0 }
                        )
                    )
                }
            }
        }
    }
}

// MARK: - Component Card

private struct ComponentCard: View {
    let component: MealComponent
    @Binding var multiplier: Double
    
    private var scaledQuantity: Double {
        component.quantity * multiplier
    }
    
    private var scaledFamiliarQuantity: Double? {
        guard let familiarQty = component.familiarQuantity else { return nil }
        return familiarQty * multiplier
    }
    
    private func formatFamiliarQuantity(_ quantity: Double, unit: String) -> String {
        let qty = Int(quantity)
        let unitUpper = unit.uppercased()
        let displayUnit: String
        if unitUpper.contains("PIECE") || unitUpper.contains("STYCK") {
            displayUnit = qty == 1 ? "STYCK" : "STYCKEN"
        } else {
            displayUnit = unitUpper
        }
        return "\(qty) \(displayUnit)"
    }
    
    var body: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                // Header with name and edit icon
                HStack {
                    Text(component.name)
                        .font(AppTheme.Typography.heading3)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "pencil")
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.Colors.textTertiary)
                }
                
                // Quantity and Weight
                HStack {
                    if let familiarQty = scaledFamiliarQuantity, let familiarUnit = component.familiarUnit {
                        Text(formatFamiliarQuantity(familiarQty, unit: familiarUnit))
                            .font(AppTheme.Typography.bodyMedium)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Text("VIKT \(Int(scaledQuantity)) G")
                        .font(AppTheme.Typography.bodyMedium)
                        .fontWeight(.semibold)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                
                // Slider
                QuantitySlider(
                    value: $multiplier,
                    range: 0.1...3.0,
                    step: 0.1,
                    label: "",
                    unit: ""
                )
                
                // Macro breakdown
                HStack(spacing: AppTheme.Spacing.md) {
                    MacroValue(
                        iconName: "Calories",
                        value: Int(component.calories * multiplier),
                        label: "KCAL",
                        color: AppTheme.Colors.calories
                    )
                    
                    MacroValue(
                        iconName: "Protein",
                        value: Int(component.protein * multiplier),
                        label: "",
                        color: AppTheme.Colors.protein
                    )
                    
                    MacroValue(
                        iconName: "Carbs",
                        value: Int(component.carbs * multiplier),
                        label: "",
                        color: AppTheme.Colors.carbs
                    )
                    
                    MacroValue(
                        iconName: "Fat",
                        value: Int(component.fat * multiplier),
                        label: "",
                        color: AppTheme.Colors.fat
                    )
                }
            }
        }
    }
}

private struct MacroValue: View {
    let iconName: String
    let value: Int
    let label: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            MacroIcon(iconName: iconName, tint: color, size: 14)
            Text("\(value)")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(color)
            
            if !label.isEmpty {
                Text(label)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
        }
    }
}

// MARK: - Previews

#Preview("Meal Detail - Full") {
    NavigationStack {
        MealDetailView(meal: MockData.sampleBreakfast)
    }
}

#Preview("Many Components") {
    NavigationStack {
        MealDetailView(meal: MockData.sampleBreakfast)
    }
}

#Preview("High Fat Meal") {
    NavigationStack {
        MealDetailView(meal: MockData.mealWithHighCalories)
    }
}

#Preview("With Allergens") {
    NavigationStack {
        MealDetailView(meal: MockData.mealWithAllergens)
    }
}

#Preview("Low Confidence") {
    NavigationStack {
        MealDetailView(meal: MockData.mealWithLowConfidence)
    }
}

#Preview("No Image") {
    NavigationStack {
        MealDetailView(meal: MockData.mealWithoutImage)
    }
}

#Preview("Simple Meal") {
    NavigationStack {
        MealDetailView(meal: MockData.coffeeSnack)
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        MealDetailView(meal: MockData.sampleLunch)
    }
    .preferredColorScheme(.dark)
}

#Preview("Large Dynamic Type") {
    NavigationStack {
        MealDetailView(meal: MockData.sampleBreakfast)
    }
    .environment(\.dynamicTypeSize, .accessibility2)
}
