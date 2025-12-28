import SwiftUI

/// MealCard displays a compact summary of a meal with image, title, time, and macro breakdown.
/// - Parameters:
///   - title: Meal title shown prominently.
///   - calories: Total calories for the meal.
///   - protein: Protein grams.
///   - carbs: Carbohydrates grams.
///   - fat: Fat grams.
///   - time: Time string (e.g., "9:37 AM").
///   - image: Optional image to display; a placeholder is shown if nil.
struct MealCard: View {
    let title: String
    let calories: Int
    let protein: Int
    let carbs: Int
    let fat: Int
    let time: String
    let image: Image?
    
    private let cornerRadius: CGFloat = AppTheme.CornerRadius.lg
    
    var body: some View {
        CardContainer(padding: 0, cornerRadius: cornerRadius, isActive: true) {
            HStack(spacing: 0) {
                // Leading image (or placeholder)
                MealImageView(image: image)
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    // Title
                    Text(title)
                        .font(AppTheme.Typography.heading3)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .minimumScaleFactor(0.8)
                        .allowsTightening(true)
                    
                    HStack(alignment: .center, spacing: AppTheme.Spacing.xs) {
                        // Macro summary row
                        MacroPillRow(calories: calories, protein: protein, carbs: carbs, fat: fat)
                        
                        Text(time)
                            .font(AppTheme.Typography.captionTiny)
                            .foregroundColor(AppTheme.Colors.textTertiary)
                            .lineLimit(1)
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.sm)
                .padding(.vertical, AppTheme.Spacing.sm)
                
                Spacer(minLength: 0)
            }
        }
        .frame(height: 100)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

// MARK: - Subviews

/// Displays the meal image with a fallback placeholder. Sized to 100x100 and clipped.
private struct MealImageView: View {
    let image: Image?
    
    var body: some View {
        Group {
            if let image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                ZStack {
                    //AppTheme.Colors.imagePlaceholder
                    AppTheme.Colors.secondary
                    Image(systemName: "photo")
                        .foregroundColor(AppTheme.Colors.primary)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Meal image placeholder")
            }
        }
        .frame(width: 100, height: 100)
        .clipped()
    }
}


/// Shows calories (emphasized) and macro values in a pill-like row.
private struct MacroPillRow: View {
    let calories: Int
    let protein: Int
    let carbs: Int
    let fat: Int
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.xs) {
            
            // Calories (slightly emphasized)
            MacroIconValue(
                iconName: "Calories",
                tint: AppTheme.Colors.calories,
                value: calories,
                valueFont: AppTheme.Typography.numberMedium,
                bold: true,
                iconSize: 16
            )
            // Let it compress, but don't let it steal everything
            .frame(minWidth: 0, idealWidth: 90, alignment: .leading)
            .layoutPriority(2)
            Spacer()
            // Macros group (share remaining space)
            HStack(spacing: AppTheme.Spacing.xs) {
                MacroIconValue(iconName: "Protein", tint: AppTheme.Colors.protein, value: protein)
                
                MacroIconValue(iconName: "Carbs", tint: AppTheme.Colors.carbs, value: carbs)
                
                
                MacroIconValue(iconName: "Fat", tint: AppTheme.Colors.fat, value: fat)
                
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
            .layoutPriority(1)
        }
        .font(AppTheme.Typography.numberSmall)
        .lineLimit(1)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(AppTheme.Colors.calories.opacity(0.1))
        .cornerRadius(AppTheme.CornerRadius.sm)
    }
}

/// Renders a small tinted icon with an adjacent numeric value.
/// Both icon AND value are allowed to shrink together.
private struct MacroIconValue: View {
    let iconName: String
    let tint: Color
    let value: Int
    var valueFont: Font? = nil
    var bold: Bool = false
    var iconSize: CGFloat = 12
    
    var body: some View {
        ViewThatFits(in: .horizontal) {
            row(icon: iconSize, font: valueFont ?? AppTheme.Typography.numberSmall)
            row(icon: iconSize * 0.85, font: AppTheme.Typography.captionTiny)
            row(icon: iconSize * 0.70, font: AppTheme.Typography.captionTiny)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(value)")
    }
    
    @ViewBuilder
    private func row(icon: CGFloat, font: Font) -> some View {
        HStack(spacing: 2) {
        
            
            MacroIcon(iconName: iconName, tint: tint, size: icon)
            
            Text("\(value)")
                .foregroundColor(tint)
                .font(font)
                .fontWeight(bold ? .bold : .regular)
                .lineLimit(1)
                .minimumScaleFactor(0.65)  // text can still shrink a bit
                .allowsTightening(true)
        }
        .fixedSize(horizontal: true, vertical: false) // “hug” content
    }
}

// MARK: - Previews

#Preview("Populated") {
    VStack(spacing: AppTheme.Spacing.md) {
        MealCard(
            title: "Greek Yogurt with Berries",
            calories: 348,
            protein: 9,
            carbs: 28,
            fat: 21,
            time: "9:37 AM",
            image: nil
        )
        
        MealCard(
            title: "Salmon Salad",
            calories: 540,
            protein: 35,
            carbs: 12,
            fat: 32,
            time: "1:15 PM",
            image: nil
        )
    }
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("Dark Mode") {
    VStack(spacing: AppTheme.Spacing.md) {
        MealCard(
            title: "Coffee with Milk",
            calories: 26,
            protein: 2,
            carbs: 3,
            fat: 1,
            time: "11:04 AM",
            image: nil
        )
    }
    .padding()
    .background(AppTheme.Colors.background)
    .preferredColorScheme(.dark)
}

#Preview("Long Title") {
    MealCard(
        title: "Very long meal name that might wrap or truncate if we don't handle it properly in the UI",
        calories: 1200,
        protein: 500,
        carbs: 100,
        fat: 400,
        time: "8:00 PM",
        image: nil
    )
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("Large Dynamic Type") {
    MealCard(
        title: "Kaffe med mjölk",
        calories: 26,
        protein: 2,
        carbs: 3,
        fat: 1,
        time: "11:04",
        image: nil
    )
    .padding()
    .background(AppTheme.Colors.background)
    .environment(\.dynamicTypeSize, .accessibility2)
}

