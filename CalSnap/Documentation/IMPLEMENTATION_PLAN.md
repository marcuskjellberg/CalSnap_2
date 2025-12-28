# CalSnap – UI-First Implementation Plan

## 📦 Phases Overview

| Phase | Goal | Status |
| --- | --- | --- |
| 0 | Project & workflow setup | ✅ Done |
| 1 | Design system | ✅ Done |
| 2 | Reusable UI components | ✅ Done |
| 3 | Mock models & data |  ✅ Done |
| 4 | Navigation shell | ✅ Done  |
| 5 | Home screen | ⬜ |
| 6 | Meal detail screen | ⬜ |
| 7 | Settings | ⬜ |
| 8 | Goal wizard | ⬜ |
| 9 | UX polish | ⬜ |
| 10 | Backend & AI (later) | ⬜ |

This document defines **exactly how CalSnap is built**, in which order, and under which constraints.

It is written to be used by:

- You (as the product owner / developer)
- Cursor (as a guided coding agent)

If anything is unclear, **slow down and improve the UI**, not the backend.

---

## 🎯 Core Objective

Build the **most frictionless meal-logging UI possible**:

- Fast to log
- Fast to correct
- Easy to understand
- Pleasant to use
- Visually correct in all states

**Backend, AI, persistence, and monetization come later.**

---

## 🧱 Global Rules (Non-Negotiable)

1. **UI-first**
    - No backend code until all major screens feel right.
2. **Preview-driven**
    - Every View and Component must compile and render in SwiftUI previews.
3. **Mock data only**
    - All screens use `MockData` until Phase 10.
4. **Design system first**
    - No hard-coded colors, fonts, or spacing in feature code.
5. **Editability over accuracy**
    - It must be easier to correct AI output than to re-log food.
6. **Docs win**
    - If code and docs conflict, docs win.

## **Phase 0 — Project + Workflow Setup (30–60 min)**

1. **Create Xcode project**
    - iOS App → SwiftUI → "CalSnap"
    - Minimum iOS: iOS 17+ (for modern SwiftUI + #Preview)
2. **Open the project folder in Cursor**
    - Cursor becomes your "code + refactor + generate scaffolding" tool
    - Keep Xcode for previews + running on device/simulator
3. **Add a clean folder structure**
    - App/
    - Features/Home/
    - Features/MealDetail/
    - Features/Settings/
    - Features/Goals/
    - DesignSystem/ (colors/typography/spacings/buttons/cards)
    - Models/
    - MockData/

## **Phase 1 — Build the Design System (so UI is consistent)**

1. Create AppTheme.swift (Colors, Typography, Spacing, CornerRadius)
2. Create reusable UI components (each with its own Preview):
    - PrimaryButton
    - IconButton
    - BottomPromptBar (photo, favorite, voice, text, send)
    - CardContainer
    - MacroPill / MacroRow
    - MealCard
    - DailyTrackerCard
    - HealthScoreCard
    - QuantitySlider (value + unit labels)

**Rule:** Every component file ends with a #Preview showing:

- Normal
- Disabled
- Loading
- Long text edge case

## **Phase 2 — Reusable UI Components**

Build all reusable components defined in the design system with comprehensive previews:

1. **Buttons**
    - PrimaryButton
    - SecondaryButton
    - IconButton
    - TextButton
2. **Cards**
    - BaseCard
    - ProgressCard
    - InfoCard
    - SelectionCard
3. **Input**
    - TextInputField
    - SliderControl
    - VoiceInputButton
    - SearchBar
4. **Display**
    - ProgressBar
    - MacroPill
    - Badge
    - AllergenBadge
    - HealthBadge
5. **Lists**
    - MealListItem
    - ComponentListItem
    - SettingsListItem
6. **Common**
    - LoadingView
    - EmptyStateView
    - ErrorView
    - DividerLine
    - ImageView

**Rule:** Each component has minimum 3 preview variants (normal, edge case, dark mode).

## **Phase 3 — Mock Data + Models (UI without backend)**

1. Create lightweight models:
    - Meal
    - MealComponent
    - DailySummary / DailyProgress
    - DailyGoals
    - UserPreferences
2. Create MockData.swift with:
    - static let sampleMeals: [Meal]
    - static let sampleMeal: Meal
    - Multiple sample meals: breakfast/lunch/dinner, varied macros, missing image, "uncertain" meal

This lets you build every screen with realistic content.

## **Phase 4 — Navigation + Screen Shells**
x
1. Implement a simple app router first:
    - NavigationStack
    - Home pushes MealDetail
    - Top-right Settings opens a sheet

Keep it dead simple:

- No persistence
- No AI
- All views use mock data

## **Phase 5 — Screen 1: Home (wireframe → polished)**

1. Build HomeView in this order:
    1. TopBar (title + settings icon)
    2. DailyTrackerCard (progress bars/rings can be placeholders)
    3. MealsList (MealCard components)
    4. BottomPromptBar docked at bottom
2. Make HomeViewModel (mock)
- @Published var meals: [Meal] = MockData.sampleMeals
- @Published var dailySummary = MockData.sampleDailySummary
- Tapping "Send" just appends a dummy meal for now (so you can test the UI flow)
1. Add #Preview variants:
- Empty day (no meals)
- Lots of meals (scroll)
- Dark mode
- Large text accessibility

## **Phase 6 — Screen 2: Meal Detail (wireframe → interactions)**

1. Build MealDetailView sections:
2. Image header + totals (kcal, P/C/F)
3. HealthScoreCard
4. Portion slider (scales totals)
5. Components list (editable cards)
6. BottomPromptBar for "Update this meal"
7. Implement "UI-only interactions":
- Portion slider changes portionFactor and updates displayed totals
- Component slider changes that component amount and updates totals
- Swipe left/right for "previous/next meal" *optional* (can be added later)
1. Add MealDetailViewModel that:
- Holds base meal data + a derived "display meal"
- Performs scaling math locally (no backend)
1. Add #Preview variants:
- High fat meal / low fiber meal (health insights visible)
- Meal with many components
- Meal with uncertain items (confidence badges)

## **Phase 7 — Screen 3: Settings**

1. Build SettingsView with:
- Language selection (UI only)
- Unit system (Metric/Imperial)
- Region preset (US/UK/EU)
- Subscription placeholder
- Data/privacy links placeholder

Add preview for each setting state.

## **Phase 8 — Screen 4: Goal Wizard (UI-only)**

1. Build GoalWizardView:
- Activity slider
- Goal selection (lose/maintain/gain)
- Macro split sliders
- "Generate suggestion" button (mock: shows a computed suggestion)
- "Save goals"

No AI yet — just local heuristic placeholders.

## **Phase 9 — UX Polish Pass (before backend)**

1. Add UX behaviors:
- Loading skeleton states (Home and MealDetail)
- Empty states with friendly CTA
- Haptics on sliders and primary actions
- Micro animations (button press, card transitions)
- Keyboard handling for BottomPromptBar
1. Add "Preview Gallery"
    
    Create a PreviewGallery.swift that displays all screens and components in one place so you can check everything fast.
    

Example:

- HomeView (empty)
- HomeView (populated)
- MealDetailView (sampleMeal)
- SettingsView
- GoalWizardView
- Components showcase

## **Phase 10 — When UI feels done → integrate backend/AI**

1. Only after UI is approved:
- Add networking layer + backend proxy
- Replace mock "Send" with "AnalyzeMeal"
- Replace mock "Update" with "AugmentMeal"
- Add persistence (SwiftData + CloudKit)
- Add StoreKit 2

---

# **How to use Cursor effectively (UI-first)**

In Cursor, work file-by-file:

- "Create HomeView layout using these components"
- "Add previews for empty/populated/dark mode/large text"
- "Refactor repeated UI into reusable components"
- "Add ViewModel scaling logic for portionFactor"

Good Cursor prompts for this phase:

- "Generate a SwiftUI screen stub matching this spec with mock data only and full previews."
- "Create a reusable component with 3 previews: normal/disabled/loading."
- "Create a PreviewGallery that lists every view for fast visual QA."

---

# **Concrete build order (the exact sequence to follow)**

1. ✅ AppTheme + PrimaryButton + CardContainer
2. ✅ MacroRow + MealCard + DailyTrackerCard
3. ✅ BottomPromptBar + all other components
4. ⏳ Models + MockData (Phase 3 - NEXT)
5. ⬜ HomeView + HomeViewModel + previews
6. ⬜ MealDetailView + ViewModel scaling + previews
7. ⬜ SettingsView + previews
8. ⬜ GoalWizardView + previews
9. ⬜ PreviewGallery
10. ⬜ UX polish + states
11. ⬜ Backend later

---

## Target Platform

**iOS 17.0+** - This allows us to use:

- Modern SwiftUI features
- `#Preview` macro (cleaner than PreviewProvider)
- SwiftData for future persistence
- Latest StoreKit 2 APIs

If you paste your current repo structure or your existing files (even partial), I can output:

- The exact file tree
- The exact SwiftUI stubs for each view
- A PreviewGallery you can run immediately
- A mock data model that matches your PRD

---

## Ready for Phase 3?

Phase 3 (Mock Models & Data) is next. This will create:

- All data models from the spec
- Comprehensive mock data for every scenario
- Helper extensions for testing

Say "Start Phase 3" when ready!