import SwiftUI

/// Custom slider with label, value display, and haptic feedback.
/// Uses Asset-based colors for automatic Light/Dark mode support.
struct QuantitySlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let label: String
    let unit: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            if !label.isEmpty || !unit.isEmpty {
                HStack {
                    if !label.isEmpty {
                        Text(label)
                            .font(AppTheme.Typography.bodySmall)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                    
                    Spacer()
                    
                    if !unit.isEmpty {
                        Text("\(Int(value)) \(unit)")
                            .font(AppTheme.Typography.numberSmall)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(label.isEmpty ? "" : label + ": ")\(Int(value)) \(unit.isEmpty ? "" : unit)")
            }
            
            Slider(value: $value, in: range, step: step)
                .tint(AppTheme.Colors.primary)
                .onChange(of: value) { _, _ in
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }
                .accessibilityValue("\(Int(value))\(unit.isEmpty ? "" : " \(unit)")")
        }
    }
}

// MARK: - Previews

#Preview("Standard Slider") {
    struct PreviewWrapper: View {
        @State var val: Double = 100
        var body: some View {
            QuantitySlider(
                value: $val,
                range: 0...500,
                step: 5,
                label: "PORTION SIZE",
                unit: "g"
            )
            .padding()
            .background(AppTheme.Colors.background)
        }
    }
    return PreviewWrapper()
}

#Preview("Percentage Slider") {
    struct PreviewWrapper: View {
        @State var val: Double = 100
        var body: some View {
            QuantitySlider(
                value: $val,
                range: 50...200,
                step: 10,
                label: "TOTAL PORTION",
                unit: "%"
            )
            .padding()
            .background(AppTheme.Colors.background)
        }
    }
    return PreviewWrapper()
}

#Preview("Dark Mode") {
    struct PreviewWrapper: View {
        @State var val: Double = 100
        var body: some View {
            QuantitySlider(
                value: $val,
                range: 0...500,
                step: 5,
                label: "PORTION SIZE",
                unit: "g"
            )
            .padding()
            .background(AppTheme.Colors.background)
            .preferredColorScheme(.dark)
        }
    }
    return PreviewWrapper()
}

#Preview("Large Dynamic Type") {
    struct PreviewWrapper: View {
        @State var val: Double = 100
        var body: some View {
            QuantitySlider(
                value: $val,
                range: 0...500,
                step: 5,
                label: "PORTION SIZE",
                unit: "g"
            )
            .padding()
            .background(AppTheme.Colors.background)
            .environment(\.dynamicTypeSize, .accessibility2)
        }
    }
    return PreviewWrapper()
}
