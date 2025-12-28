//
//  SettingsView.swift
//  CalSnap
//
//  User settings and preferences
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Mock preferences for UI development
    @State private var preferences = MockData.sampleUserPreferences
    @State private var showGoalsSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                // Profile Section
                Section {
                    NavigationLink {
                        GoalsSettingsView()
                    } label: {
                        SettingsRow(
                            icon: "target",
                            iconColor: AppTheme.Colors.primary,
                            title: "Daily Goals",
                            subtitle: "\(Int(MockData.sampleDailyGoals.calorieTarget)) kcal"
                        )
                    }
                    
                    NavigationLink {
                        DietarySettingsView()
                    } label: {
                        SettingsRow(
                            icon: "leaf",
                            iconColor: AppTheme.Colors.carbs,
                            title: "Dietary Preferences",
                            subtitle: preferences.dietaryPreferences.isEmpty ? "None set" : "\(preferences.dietaryPreferences.count) preferences"
                        )
                    }
                    
                    NavigationLink {
                        AllergenSettingsView()
                    } label: {
                        SettingsRow(
                            icon: "exclamationmark.triangle",
                            iconColor: AppTheme.Colors.secondary,
                            title: "Allergens",
                            subtitle: preferences.allergens.isEmpty ? "None set" : "\(preferences.allergens.count) allergens"
                        )
                    }
                } header: {
                    Text("Nutrition")
                }
                
                // App Settings Section
                Section {
                    Picker("Theme", selection: $preferences.theme) {
                        ForEach(ThemeMode.allCases, id: \.self) { mode in
                            Text(mode.displayName).tag(mode)
                        }
                    }
                    
                    Picker("Units", selection: $preferences.unitSystem) {
                        ForEach(UnitSystem.allCases, id: \.self) { system in
                            Text(system.displayName).tag(system)
                        }
                    }
                    
                    Toggle("Haptic Feedback", isOn: $preferences.enableHaptics)
                    
                    Toggle("Sound Effects", isOn: $preferences.enableSounds)
                } header: {
                    Text("App Settings")
                }
                
                // Privacy Section
                Section {
                    Toggle("iCloud Sync", isOn: $preferences.enableiCloudSync)
                    
                    Toggle("Analytics", isOn: $preferences.enableAnalytics)
                    
                    Toggle("Location Tracking", isOn: $preferences.enableLocationTracking)
                } header: {
                    Text("Privacy")
                } footer: {
                    Text("Location is used to tag meals with where you ate them.")
                }
                
                // About Section
                Section {
                    NavigationLink {
                        AboutView()
                    } label: {
                        SettingsRow(
                            icon: "info.circle",
                            iconColor: AppTheme.Colors.textSecondary,
                            title: "About CalSnap",
                            subtitle: "Version 1.0.0"
                        )
                    }
                    
                    Link(destination: URL(string: "https://example.com/privacy")!) {
                        SettingsRow(
                            icon: "hand.raised",
                            iconColor: AppTheme.Colors.textSecondary,
                            title: "Privacy Policy",
                            subtitle: nil
                        )
                    }
                    
                    Link(destination: URL(string: "https://example.com/terms")!) {
                        SettingsRow(
                            icon: "doc.text",
                            iconColor: AppTheme.Colors.textSecondary,
                            title: "Terms of Service",
                            subtitle: nil
                        )
                    }
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

// MARK: - Supporting Views

private struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String?
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(iconColor)
                .frame(width: 28)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppTheme.Typography.bodyMedium)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(AppTheme.Typography.captionLarge)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
            }
        }
    }
}

// MARK: - Placeholder Views

struct GoalsSettingsView: View {
    var body: some View {
        List {
            Section {
                Text("Calorie Target: 2000 kcal")
                Text("Protein Target: 150g")
                Text("Carbs Target: 200g")
                Text("Fat Target: 67g")
            } header: {
                Text("Daily Targets")
            }
        }
        .navigationTitle("Daily Goals")
    }
}

struct DietarySettingsView: View {
    var body: some View {
        List {
            ForEach(DietaryTag.allCases, id: \.self) { tag in
                HStack {
                    Text(tag.icon)
                    Text(tag.displayName)
                    Spacer()
                }
            }
        }
        .navigationTitle("Dietary Preferences")
    }
}

struct AllergenSettingsView: View {
    var body: some View {
        List {
            ForEach(Allergen.allCases, id: \.self) { allergen in
                HStack {
                    Text(allergen.icon)
                    Text(allergen.displayName)
                    Spacer()
                }
            }
        }
        .navigationTitle("Allergens")
    }
}

struct AboutView: View {
    var body: some View {
        List {
            Section {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                
                HStack {
                    Text("Build")
                    Spacer()
                    Text("1")
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
            }
            
            Section {
                Text("CalSnap uses AI to analyze your meals and provide instant nutrition information.")
                    .font(AppTheme.Typography.bodySmall)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            } header: {
                Text("About")
            }
        }
        .navigationTitle("About CalSnap")
    }
}

// MARK: - Previews

#Preview("Settings") {
    SettingsView()
}

#Preview("Settings - Dark Mode") {
    SettingsView()
        .preferredColorScheme(.dark)
}

#Preview("Goals Settings") {
    NavigationStack {
        GoalsSettingsView()
    }
}

#Preview("Dietary Settings") {
    NavigationStack {
        DietarySettingsView()
    }
}

#Preview("Allergen Settings") {
    NavigationStack {
        AllergenSettingsView()
    }
}

