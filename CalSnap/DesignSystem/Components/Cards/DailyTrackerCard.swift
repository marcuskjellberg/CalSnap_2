import SwiftUI

/// Main dashboard card showing daily calorie and macro progress.
/// Uses Dynamic Type and Asset-based colors for accessibility and Light/Dark mode.
struct DailyTrackerCard: View {
    let caloriesConsumed: Int
    let calorieTarget: Int
    let proteinConsumed: Double
    let proteinTarget: Double
    let carbsConsumed: Double
    let carbsTarget: Double
    let fatConsumed: Double
    let fatTarget: Double
    let mealCount: Int
    
    init(
        caloriesConsumed: Int,
        calorieTarget: Int,
        proteinConsumed: Double,
        proteinTarget: Double,
        carbsConsumed: Double,
        carbsTarget: Double,
        fatConsumed: Double,
        fatTarget: Double,
        mealCount: Int = 2
    ) {
        self.caloriesConsumed = caloriesConsumed
        self.calorieTarget = calorieTarget
        self.proteinConsumed = proteinConsumed
        self.proteinTarget = proteinTarget
        self.carbsConsumed = carbsConsumed
        self.carbsTarget = carbsTarget
        self.fatConsumed = fatConsumed
        self.fatTarget = fatTarget
        self.mealCount = mealCount
    }
    
    var calorieProgress: Double {
        guard calorieTarget > 0 else { return 0 }
        return Double(caloriesConsumed) / Double(calorieTarget)
    }
    
    var body: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                // Header
                HStack {
                    Text("TODAY")
                        .font(AppTheme.Typography.captionLarge)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                    
                    Spacer()
                    
                    Text("\(mealCount) MEALS")
                        .font(AppTheme.Typography.captionLarge)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Today, \(mealCount) meals logged")
                
                // Calories Section
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    HStack(alignment: .lastTextBaseline) {
                        Text("CALORIES")
                            .font(AppTheme.Typography.heading3)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                        
                        Spacer()
                        
                        Text("\(Int(calorieProgress * 100))%")
                            .font(AppTheme.Typography.numberMedium)
                            .foregroundColor(AppTheme.Colors.calories)
                    }
                    HStack(alignment: .center) {
                        MacroIcon(iconName: "Calories", tint: AppTheme.Colors.calories, size: AppTheme.IconSize.xl)
                        HStack(alignment: .lastTextBaseline, spacing: 4) {
                            
                            
                            
                            Text("\(caloriesConsumed)")
                                .font(AppTheme.Typography.numberLarge)
                                .foregroundColor(AppTheme.Colors.textPrimary)
                            
                            Text("/ \(calorieTarget) kcal")
                                .font(AppTheme.Typography.bodyMedium)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("\(caloriesConsumed) of \(calorieTarget) calories")
                    }
                    
                    // Calorie Progress Bar
                    ProgressBar(
                        progress: min(calorieProgress, 1.0),
                        color: AppTheme.Colors.calories,
                        height: 12
                    )
                }
                
                Divider()
                    .background(AppTheme.Colors.divider)
                    .padding(.vertical, AppTheme.Spacing.xs)
                
                // Macros Section
                VStack(spacing: AppTheme.Spacing.md) {
                    MacroProgressRow(label: "PROTEIN", current: proteinConsumed, target: proteinTarget, color: AppTheme.Colors.protein, iconName: "Protein")
                    MacroProgressRow(label: "CARBS", current: carbsConsumed, target: carbsTarget, color: AppTheme.Colors.carbs, iconName: "Carbs")
                    MacroProgressRow(label: "FAT", current: fatConsumed, target: fatTarget, color: AppTheme.Colors.fat, iconName: "Fat")
                }
            }
        }
    }
}



/// Reusable progress bar component.
private struct ProgressBar: View {
    let progress: Double
    let color: Color
    var height: CGFloat = 8
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(AppTheme.Colors.progressBackground)
                    .frame(height: height)
                
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(color)
                    .frame(width: geometry.size.width * CGFloat(progress), height: height)
                    .animation(.spring(duration: 0.5), value: progress)
            }
        }
        .frame(height: height)
        .accessibilityElement()
        .accessibilityValue("\(Int(progress * 100)) percent")
    }
}

/// Macro row showing icon, label, current and target value with progress bar.
private struct MacroProgressRow: View {
    let label: String
    let current: Double
    let target: Double
    let color: Color
    let iconName: String
    
    private var progress: Double {
        guard target > 0 else { return 0 }
        return min(current / target, 1.0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            HStack(alignment: .center, spacing: AppTheme.Spacing.sm) {
                MacroIcon(iconName: iconName, tint: color, size: AppTheme.IconSize.sm)
                
                Text(label)
                    .font(AppTheme.Typography.bodyMedium)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                
                Spacer()
                
                Text("\(Int(current))/\(Int(target)) g")
                    .font(AppTheme.Typography.bodyMedium)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            
            ProgressBar(progress: progress, color: color)
                .frame(height: 8)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label) \(Int(current)) grams of \(Int(target)) grams")
    }
}

// MARK: - Previews

#Preview("Standard") {
    DailyTrackerCard(
        caloriesConsumed: 374,
        calorieTarget: 2304,
        proteinConsumed: 11,
        proteinTarget: 167,
        carbsConsumed: 31,
        carbsTarget: 272,
        fatConsumed: 22,
        fatTarget: 61
    )
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("Near Target") {
    DailyTrackerCard(
        caloriesConsumed: 2100,
        calorieTarget: 2304,
        proteinConsumed: 150,
        proteinTarget: 167,
        carbsConsumed: 220,
        carbsTarget: 272,
        fatConsumed: 55,
        fatTarget: 61,
        mealCount: 5
    )
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("Dark Mode") {
    DailyTrackerCard(
        caloriesConsumed: 850,
        calorieTarget: 2000,
        proteinConsumed: 60,
        proteinTarget: 150,
        carbsConsumed: 100,
        carbsTarget: 200,
        fatConsumed: 30,
        fatTarget: 70,
        mealCount: 3
    )
    .padding()
    .background(AppTheme.Colors.background)
    .preferredColorScheme(.dark)
}

#Preview("Large Dynamic Type") {
    DailyTrackerCard(
        caloriesConsumed: 374,
        calorieTarget: 2304,
        proteinConsumed: 11,
        proteinTarget: 167,
        carbsConsumed: 31,
        carbsTarget: 272,
        fatConsumed: 22,
        fatTarget: 61
    )
    .padding()
    .background(AppTheme.Colors.background)
    .environment(\.dynamicTypeSize, .accessibility2)
}

