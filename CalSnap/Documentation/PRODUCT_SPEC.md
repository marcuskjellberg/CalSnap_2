# CalSnap - Complete Product & Design Specification

## Table of Contents

1. [Product Vision](https://www.notion.so/CalSnap-Complete-Product-Design-Specification-2d691ee7acda80ba9483ffe08c5f4561?pvs=21)
2. [Visual Design System](https://www.notion.so/CalSnap-Complete-Product-Design-Specification-2d691ee7acda80ba9483ffe08c5f4561?pvs=21)
3. [Screen Specifications](https://www.notion.so/CalSnap-Complete-Product-Design-Specification-2d691ee7acda80ba9483ffe08c5f4561?pvs=21)
4. [Data Models](https://www.notion.so/CalSnap-Complete-Product-Design-Specification-2d691ee7acda80ba9483ffe08c5f4561?pvs=21)
5. [Localization Strategy](https://www.notion.so/CalSnap-Complete-Product-Design-Specification-2d691ee7acda80ba9483ffe08c5f4561?pvs=21)
6. [Project Structure](https://www.notion.so/CalSnap-Complete-Product-Design-Specification-2d691ee7acda80ba9483ffe08c5f4561?pvs=21)
7. [Reusable UI Components](https://www.notion.so/CalSnap-Complete-Product-Design-Specification-2d691ee7acda80ba9483ffe08c5f4561?pvs=21)
8. [Implementation Guide](https://www.notion.so/CalSnap-Complete-Product-Design-Specification-2d691ee7acda80ba9483ffe08c5f4561?pvs=21)

---

## 1. Product Vision

CalSnap is a frictionless, AI-powered meal tracking app for iOS that makes logging food faster than thinking about it.

### Core Principles

- **Zero-friction logging**: Photo, voice, or text → instant structured analysis
- **Fast correction**: AI is never perfect → editing must be easier than re-logging
- **Clear daily tracking**: Calories + macros tracked against daily goals
- **Privacy-first**: No mandatory login, local + iCloud sync
- **Multi-language support**: Full localization with AI-powered language detection
- **Accessibility**: WCAG AA compliant, full VoiceOver support

---

## 2. Visual Design System

This design system follows iOS best practices with a **3-layer color architecture**, **Dynamic Type-friendly typography**, and **Assets.xcassets-based dark mode** handling.

### Design Principles

1. **Semantic over literal**: Use role-based names (`TextPrimary`) not mode-specific (`dark_text_primary`)
2. **Assets handle appearance**: Light/Dark variants live in `.xcassets`, not in code
3. **Dynamic Type first**: Map to Apple's text styles, then customize weight/design
4. **Accessibility encoded**: Minimum contrast ratios (WCAG AA), never rely on color alone
5. **Minimal shadows**: iOS prefers subtle elevation via background contrast

---

### Color Architecture (3 Layers)

### Layer 1 — Brand Colors (rarely used directly)

Reserved for marketing, hero elements, and rare accents. Not for everyday UI.

```
Assets.xcassets/Colors/Brand/
├─ BrandGreen      Light: #10B981  Dark: #34D399
├─ BrandOrange     Light: #F59E0B  Dark: #FBBF24
└─ BrandRed        Light: #EF4444  Dark: #F87171

```

### Layer 2 — Domain Colors (macros, health)

Semantic colors tied to app-specific meaning. Each has Light + Dark variants in Assets.

```
Assets.xcassets/Colors/Domain/
├─ Calories        Light: #F97316  Dark: #FB923C
├─ Protein         Light: #EC4899  Dark: #F472B6
├─ Carbs           Light: #10B981  Dark: #34D399
├─ Fat             Light: #3B82F6  Dark: #60A5FA
├─ Fiber           Light: #8B5CF6  Dark: #A78BFA
│
├─ HealthExcellent Light: #059669  Dark: #10B981
├─ HealthGood      Light: #10B981  Dark: #34D399
├─ HealthModerate  Light: #F59E0B  Dark: #FBBF24
├─ HealthFair      Light: #F97316  Dark: #FB923C
└─ HealthPoor      Light: #EF4444  Dark: #F87171

```

### Layer 3 — UI Role Colors (most important)

These are the colors used 90% of the time. **One name, Assets handles Light/Dark.**

```
Assets.xcassets/Colors/UI/
├─ TextPrimary        Light: #111827  Dark: #F9FAFB
├─ TextSecondary      Light: #6B7280  Dark: #D1D5DB
├─ TextTertiary       Light: #9CA3AF  Dark: #9CA3AF
│
├─ BackgroundPrimary  Light: #FFFFFF  Dark: #111827
├─ BackgroundSecondary Light: #F9FAFB Dark: #1F2937
├─ CardBackground     Light: #FFFFFF  Dark: #1F2937
│
├─ Divider            Light: #E5E7EB  Dark: #374151
├─ Border             Light: #E5E7EB  Dark: #374151
│
├─ StatusSuccess      Light: #10B981  Dark: #34D399
├─ StatusWarning      Light: #F59E0B  Dark: #FBBF24
└─ StatusError        Light: #EF4444  Dark: #F87171

```

### SwiftUI Usage

```swift
// ✅ Correct: semantic, Assets-based
Text("Hello")
    .foregroundColor(Color("TextPrimary"))

// ❌ Avoid: hard-coded, mode-specific
Text("Hello")
    .foregroundColor(colorScheme == .dark ? darkTextPrimary : textPrimary)

```

---

### Typography System

Map to **Apple's Dynamic Type styles** for automatic scaling and accessibility. Customize with weight and design, not hard-coded sizes.

### SwiftUI Font Extensions

```swift
extension Font {
    // MARK: - Headings (scale with Dynamic Type)
    static let displayLarge = Font.largeTitle.weight(.bold)
    static let displayMedium = Font.title.weight(.bold)
    static let displaySmall = Font.title2.weight(.semibold)

    static let heading1 = Font.title2.weight(.bold)
    static let heading2 = Font.title3.weight(.semibold)
    static let heading3 = Font.headline.weight(.semibold)

    // MARK: - Body
    static let bodyLarge = Font.body
    static let bodyMedium = Font.callout
    static let bodySmall = Font.subheadline

    // MARK: - Captions
    static let captionLarge = Font.footnote
    static let captionSmall = Font.caption
    static let captionTiny = Font.caption2

    // MARK: - Numbers (Rounded design for data)
    static let numberLarge = Font.system(.largeTitle, design: .rounded).weight(.semibold)
    static let numberMedium = Font.system(.title3, design: .rounded).weight(.semibold)
    static let numberSmall = Font.system(.callout, design: .rounded).weight(.medium)
}

```

### Why This Matters

| Approach | Dynamic Type | Accessibility | Native Feel |
| --- | --- | --- | --- |
| Hard-coded `34pt` | ❌ | ❌ | ❌ |
| `.largeTitle.weight(.bold)` | ✅ | ✅ | ✅ |

---

### Spacing System

Streamlined to 6 core values. Compose for larger gaps rather than adding more tokens.

```swift
enum Spacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
}

```

### Component-Specific (derived, not new tokens)

```swift
// Prefer composition over new constants
let cardPadding = Spacing.md        // 16
let screenMargin = Spacing.md       // 16
let sectionSpacing = Spacing.lg     // 24
let componentGap = Spacing.sm       // 12

```

---

### Corner Radius

Unchanged — this scale is production-ready.

```swift
enum CornerRadius {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let full: CGFloat = 9999  // Pills, circular elements
}

```

---

### Shadows

iOS design trends favor **minimal shadows**. Use sparingly, prefer background contrast.

```swift
enum AppShadow {
    // Primary card shadow — use only on elevated cards
    static let card = (color: Color.black.opacity(0.08), radius: 8, y: 2)

    // Optional: subtle pressed state (rarely needed)
    static let subtle = (color: Color.black.opacity(0.04), radius: 2, y: 1)
}

```

### Shadow Guidelines

- ✅ Use `card` shadow on floating cards in light mode
- ✅ Consider disabling shadows in dark mode (backgrounds provide contrast)
- ❌ Never stack multiple shadows
- ❌ Avoid shadows on inline list items

---

### Accessibility Requirements

### Contrast Ratios (WCAG AA)

| Element | Minimum Ratio |
| --- | --- |
| Body text | 4.5:1 |
| Large text (≥18pt bold) | 3:1 |
| UI components | 3:1 |
| Icons with meaning | 3:1 |

### Color Independence

Never convey meaning through color alone:

```swift
// ✅ Correct: icon + color + label
HStack {
    Image("Protein")
        .foregroundColor(Color("Protein"))
    Text("24g")
}

// ❌ Wrong: color only
Circle()
    .fill(Color("Protein"))  // What does pink mean?

```

### VoiceOver

All interactive elements must have accessibility labels:

```swift
Button(action: addMeal) {
    Image(systemName: "plus")
}
.accessibilityLabel("Add meal")

```

---

### Assets.xcassets Structure

```
Assets.xcassets/
├─ Colors/
│  ├─ Brand/
│  │  ├─ BrandGreen.colorset
│  │  ├─ BrandOrange.colorset
│  │  └─ BrandRed.colorset
│  │
│  ├─ Domain/
│  │  ├─ Calories.colorset
│  │  ├─ Protein.colorset
│  │  ├─ Carbs.colorset
│  │  ├─ Fat.colorset
│  │  ├─ Fiber.colorset
│  │  ├─ HealthExcellent.colorset
│  │  ├─ HealthGood.colorset
│  │  ├─ HealthModerate.colorset
│  │  ├─ HealthFair.colorset
│  │  └─ HealthPoor.colorset
│  │
│  └─ UI/
│     ├─ TextPrimary.colorset
│     ├─ TextSecondary.colorset
│     ├─ TextTertiary.colorset
│     ├─ BackgroundPrimary.colorset
│     ├─ BackgroundSecondary.colorset
│     ├─ CardBackground.colorset
│     ├─ Divider.colorset
│     ├─ Border.colorset
│     ├─ StatusSuccess.colorset
│     ├─ StatusWarning.colorset
│     └─ StatusError.colorset
│
├─ Icons/
│  ├─ Calories.imageset      (SF Symbol or custom)
│  ├─ Protein.imageset
│  ├─ Carbs.imageset
│  ├─ Fat.imageset
│  └─ Fiber.imageset
│
└─ AppIcon.appiconset

```

Each `.colorset` contains:

- `Any Appearance` (light mode default)
- `Dark Appearance` override

---

## 3. Screen Specifications

### 3.1 Home Screen

**Layout Structure:**

```
┌─────────────────────────────────────────┐
│  🔥 CalSnap                    👤       │  Navigation Bar
├─────────────────────────────────────────┤
│  ◀ FR LÖ SÖ MÅ TI ON TO ▶             │  Week Calendar
│     19 20 21 22 23 24 25               │
│     —  —  —  —  —  80% 16%             │
├─────────────────────────────────────────┤
│  IDAG                    2 MÅLTIDER     │  Section Header
│                                         │
│  ┌───────────────────────────────────┐ │
│  │  🔥 KALORIER           16%        │ │  Progress Card
│  │  374 / 2304 kcal                 │ │
│  │  [████░░░░░░░░░░░]               │ │
│  │                                   │ │
│  │  💪 P  ●─────  11/167 (7%)      │ │  Macro Rows
│  │  🥦 C  ●─────  31/272 (11%)     │ │
│  │  💧 F  ●────   22/61  (36%)     │ │
│  └───────────────────────────────────┘ │
│                                         │
│  ┌───────────────────────────────────┐ │
│  │ [IMG] Kaffe med mjölk      🟢    │ │  Meal Card
│  │       26 kcal • P:2 C:3 F:1      │ │
│  │       11:04                       │ │
│  └───────────────────────────────────┘ │
│                                         │
│  ┌───────────────────────────────────┐ │
│  │ [?]   Grekisk yoghurt med...     │ │  Meal Card
│  │       348 kcal • P:9 C:28 F:21   │ │
│  │       9:37                        │ │
│  └───────────────────────────────────┘ │
│                                         │
├─────────────────────────────────────────┤
│  📷  ⭐  🎤  [Lägg till måltid...] 🇸🇪│  Input Bar
└─────────────────────────────────────────┘

```

**Key Features:**

- **Week Calendar**: Horizontal scroll, shows daily completion %
- **Progress Card**:
    - Large calorie display with visual progress bar
    - Compact macro rows with mini progress bars
    - Color-coded: Green (on track), Orange (exceeding)
- **Meal Cards**:
    - 88pt height, thumbnail image (64x64pt)
    - Health badge (top-right corner)
    - Macro summary in compact format
    - Timestamp
    - Swipe-to-delete
- **Input Bar**:
    - Persistent bottom bar
    - Camera, Favorites, Voice, Text input
    - Language indicator (🇸🇪, 🇬🇧, etc.)

**Localization Keys:**

```
home.title = "CalSnap"
home.today = "IDAG" | "TODAY" | "HEUTE"
home.meals_count = "2 MÅLTIDER" | "2 MEALS" | "2 MAHLZEITEN"
home.calories = "KALORIER" | "CALORIES" | "KALORIEN"
home.input_placeholder = "Lägg till måltid..." | "Add meal..." | "Mahlzeit hinzufügen..."

```

---

### 3.2 Camera/Photo Capture Screen

**Layout Structure:**

```
┌─────────────────────────────────────────┐
│  ✕         ✓ Klar      Analysera       │  Action Bar
├─────────────────────────────────────────┤
│                                         │
│                                         │
│          [CAMERA PREVIEW]               │
│                                         │
│                                         │
│                                         │
│                                         │
│        ┌───┐        ┌───┐              │  Thumbnails
│        │ 1 │ ✕      │ 2 │ ✕            │
│        └───┘        └───┘              │
│                                         │
│    [📱]         ⚪           [📷]      │  Controls
│                                         │
│      TRYCK FÖR ATT FOTA                │
└─────────────────────────────────────────┘

```

**Features:**

- Multi-photo support (up to 5 images)
- Live camera preview
- Photo library access
- Image thumbnails with delete option
- "Klar" (Done) vs "Analysera" (Analyze) buttons
- Localized instructions

**Localization Keys:**

```
camera.done = "Klar" | "Done" | "Fertig"
camera.analyze = "Analysera" | "Analyze" | "Analysieren"
camera.instruction = "TRYCK FÖR ATT FOTA" | "TAP TO CAPTURE" | "TIPPEN ZUM FOTOGRAFIEREN"

```

---

### 3.3 Meal Detail Screen

**Layout Structure (Part 1 - Header & Overview):**

```
┌─────────────────────────────────────────┐
│  ◀                              🗑       │  Nav Overlay
│                                         │
│         [FULL MEAL IMAGE]               │  Hero Image
│            Zoom enabled                 │  (16:9)
│                                         │
├─────────────────────────────────────────┤
│           47 kcal                       │  Large Calorie
│                                         │
│  💪 0      🥦 15      💧 1              │  Macro Pills
│  PROTEIN   KOLHYDRATER   FETT          │
└─────────────────────────────────────────┘

```

**Layout Structure (Part 2 - Details):**

```
┌─────────────────────────────────────────┐
│  Sockerfritt godis och mandel           │  Meal Name
│                                         │
│  TOTAL PORTION                          │  Portion Control
│  21 G                                   │
│  [────────●─────────────]               │  Slider
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  🔍 INSIKTER                    │   │  Health Card
│  │                                 │   │
│  │  Sockerfritt godis är bättre   │   │
│  │  för blodsockret, men tänk på  │   │
│  │  att sötningsmedel kan ha en   │   │
│  │  laxerande effekt vid större   │   │
│  │  mängder.                       │   │
│  │                                 │   │
│  │  ⚠️ NÖTTER (MANDEL)             │   │  Allergen Warning
│  │                                 │   │
│  │  AI-uppskattning. Ej medicinskt│   │  Disclaimer
│  │  råd.                           │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Innehåll                2 TOTALT       │  Components
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  Sockerfria gelégodisar     🗑  │   │  Component 1
│  │  5 STYCKEN          VIKT 20 G   │   │
│  │  [────────●─────────────]       │   │  Slider
│  │  🔥 40  💪 0  🥦 15  💧 0       │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  Mandel                     🗑  │   │  Component 2
│  │  1 STYCK            VIKT 1 G    │   │
│  │  [────────●─────────────]       │   │  Slider
│  │  🔥 7   💪 0  🥦 0  💧 1        │   │
│  └─────────────────────────────────┘   │
│                                         │
│  📷  🎤  [Justera detaljer...] 🇸🇪    │  Update Bar
└─────────────────────────────────────────┘

```

**Key Features:**

1. **Hero Image Section**
    - Full-width meal photo (16:9 aspect)
    - Pinch-to-zoom enabled
    - Back button (blur background overlay)
    - Delete button (top-right)
2. **Nutrition Summary Pills**
    - Large calorie count (34pt)
    - Three macro pills with icons
    - Color-coded indicators
3. **Portion Control**
    - "TOTAL PORTION" label
    - Weight in grams
    - Slider for adjustment (50%-200%)
    - Haptic feedback at key points
    - Real-time recalculation
4. **Health Insights Card**
    - "INSIKTER" (Insights) header
    - Plain text health advice
    - Non-judgmental tone
    - **Allergen Warnings**: ⚠️ NÖTTER (MANDEL)
    - AI disclaimer at bottom
5. **Allergen Section** (NEW)
    - Prominent warning badges
    - Common allergens tracked:
        - Nuts (Nötter)
        - Dairy (Mjölk)
        - Gluten (Gluten)
        - Eggs (Ägg)
        - Soy (Soja)
        - Fish (Fisk)
        - Shellfish (Skaldjur)
        - Sesame (Sesam)
    - Icon + text format
    - Color-coded (orange/red for warnings)
6. **Components List**
    - "Innehåll" (Contents) header
    - Count indicator (2 TOTALT)
    - Each component shows:
        - Name
        - Quantity in familiar units (5 STYCKEN)
        - Weight in grams (VIKT 20 G)
        - Individual portion slider
        - Macro breakdown
        - Delete button
7. **Update Input Bar**
    - Same as home screen
    - Contextually aware
    - "Justera detaljer..." placeholder
    - Language indicator

**Additional Tracked Metrics:**

Beyond the basic macros shown, the data model tracks:

- **Micronutrients**:
    - Fiber (Fiber)
    - Sugar (Socker)
    - Sodium (Natrium)
    - Saturated Fat (Mättat fett)
    - Cholesterol (Kolesterol)
    - Vitamins (A, C, D, B12, etc.)
    - Minerals (Iron, Calcium, Zinc, etc.)
- **Meal Metadata**:
    - Meal type (Breakfast, Lunch, Dinner, Snack)
    - Preparation method (Raw, Cooked, Fried, Baked)
    - Cuisine type (Italian, Asian, Swedish, etc.)
    - Meal tags (Vegetarian, Vegan, Gluten-free, etc.)
- **AI Confidence**:
    - Overall confidence (High/Medium/Low)
    - Per-component confidence
    - Uncertainty notes
- **User Context**:
    - Time of day
    - Location (if enabled)
    - Activity level before/after
    - Mood/energy level (optional tracking)

**Localization Keys:**

```
meal.calories = "kcal"
meal.protein = "PROTEIN" | "PROTEIN" | "EIWEISS"
meal.carbs = "KOLHYDRATER" | "CARBS" | "KOHLENHYDRATE"
meal.fat = "FETT" | "FAT" | "FETT"
meal.portion = "TOTAL PORTION" | "TOTAL PORTION" | "GESAMTPORTION"
meal.weight = "G" (universal)
meal.insights = "INSIKTER" | "INSIGHTS" | "EINBLICKE"
meal.allergens = "NÖTTER" | "NUTS" | "NÜSSE"
meal.contents = "Innehåll" | "Contents" | "Inhalt"
meal.total = "TOTALT" | "TOTAL" | "GESAMT"
meal.piece = "STYCK/STYCKEN" | "PIECE/PIECES" | "STÜCK"
meal.disclaimer = "AI-uppskattning. Ej medicinskt råd." | "AI estimate. Not medical advice." | "KI-Schätzung. Keine medizinische Beratung."

```

---

### 3.4 Settings Screen

**Layout Structure:**

```
┌─────────────────────────────────────────┐
│  ◀  Inställningar                       │
├─────────────────────────────────────────┤
│                                         │
│  KONTO                                  │
│  │ iCloud-synk          [På ✓]         │
│  │ Prenumeration        [Premium]      │
│                                         │
│  DAGLIGA MÅL                            │
│  │ Kaloriermål          2 304 kcal     │
│  │ Proteinmål           167 g           │
│  │ Kolhydratsmål        272 g           │
│  │ Fettmål              61 g            │
│  │ [Kör målguide]                       │
│                                         │
│  INSTÄLLNINGAR                          │
│  │ Enhetssystem         [Metrisk ▼]    │
│  │ Språk                [Svenska ▼]    │
│  │ Region               [SE ▼]         │
│  │ Tema                 [Auto ▼]       │
│                                         │
│  ALLERGENER & KOST                      │
│  │ Mina allergener      [Redigera]     │
│  │ Kostpreferenser      [Redigera]     │
│  │ Undvik ingredienser  [Redigera]     │
│                                         │
│  INTEGRITET                             │
│  │ Data lagras lokalt   [Visa]         │
│  │ Exportera data       [Exportera]    │
│  │ Radera all data      [Radera]       │
│                                         │
│  OM                                     │
│  │ Version              1.0.0           │
│  │ Integritetspolicy    [Visa]         │
│  │ Användarvillkor      [Visa]         │
│  │ Skicka feedback      [E-post]       │
│                                         │
└─────────────────────────────────────────┘

```

**New Section: Allergens & Dietary Preferences**

Users can configure:

- Personal allergens (auto-highlighted in meals)
- Dietary preferences (vegetarian, vegan, keto, etc.)
- Ingredients to avoid
- Religious/cultural restrictions (halal, kosher, etc.)

**Localization Keys:**

```
settings.title = "Inställningar" | "Settings" | "Einstellungen"
settings.account = "KONTO" | "ACCOUNT" | "KONTO"
settings.goals = "DAGLIGA MÅL" | "DAILY GOALS" | "TÄGLICHE ZIELE"
settings.preferences = "INSTÄLLNINGAR" | "PREFERENCES" | "PRÄFERENZEN"
settings.allergens = "ALLERGENER & KOST" | "ALLERGENS & DIET" | "ALLERGENE & ERNÄHRUNG"
settings.privacy = "INTEGRITET" | "PRIVACY" | "DATENSCHUTZ"

```

---

### 3.5 Goal Wizard Flow

**Step 1: Activity Level**

```
┌─────────────────────────────────────────┐
│  Hur aktiv är du?                       │
│                                         │
│  [────────●─────────]                   │
│  Stillasittande → Mycket aktiv         │
│                                         │
│  Måttligt aktiv                         │
│  3-5 träningspass per vecka            │
│                                         │
│  [Nästa]                                │
└─────────────────────────────────────────┘

```

**Step 2: Goal Selection**

```
┌─────────────────────────────────────────┐
│  Vad är ditt mål?                       │
│                                         │
│  ┌─────────────────┐                   │
│  │  Gå ner i vikt  │ [Selected]        │
│  └─────────────────┘                   │
│  ┌─────────────────┐                   │
│  │  Behålla vikt   │                   │
│  └─────────────────┘                   │
│  ┌─────────────────┐                   │
│  │  Gå upp i vikt  │                   │
│  └─────────────────┘                   │
│                                         │
│  [Nästa]                                │
└─────────────────────────────────────────┘

```

**Step 3: Body Metrics (Optional)**

```
┌─────────────────────────────────────────┐
│  Hjälp oss personalisera (valfritt)     │
│                                         │
│  Ålder         [──●────] 35 år          │
│  Längd         [────●──] 175 cm         │
│  Vikt          [──●────] 75 kg          │
│  Kön           [Man ▼]                  │
│                                         │
│  [Hoppa över]              [Nästa]      │
└─────────────────────────────────────────┘

```

**Step 4: AI Recommendation**

```
┌─────────────────────────────────────────┐
│  Din personliga plan                    │
│                                         │
│  Baserat på din profil:                 │
│  • Måttligt aktiv                       │
│  • Mål: Gå ner i vikt                   │
│  • 35 år, 175 cm, 75 kg                 │
│                                         │
│  Dagliga mål                            │
│  Kalorier    1 800 kcal                 │
│  Protein     150 g (33%)                │
│  Kolhydrater 180 g (40%)                │
│  Fett        54 g  (27%)                │
│                                         │
│  Varför dessa siffror?                  │
│  [Visa förklaring]                      │
│                                         │
│  [Justera manuellt]  [Använd dessa]     │
└─────────────────────────────────────────┘

```

---

## 4. Data Models

### 4.1 Core Data Models

```swift
// MARK: - Meal
@Model
class Meal {
    @Attribute(.unique) var id: UUID
    var timestamp: Date
    var mealType: MealType  // breakfast, lunch, dinner, snack

    // Basic Info
    var name: String
    var summary: String?
    var imageData: Data?
    var thumbnailData: Data?

    // Nutrition (canonical units - grams/milligrams)
    var calories: Double
    var protein: Double          // g
    var carbs: Double            // g
    var fat: Double              // g
    var fiber: Double?           // g
    var sugar: Double?           // g
    var saturatedFat: Double?    // g
    var sodium: Double?          // mg
    var cholesterol: Double?     // mg

    // Micronutrients (optional)
    var vitaminA: Double?        // µg
    var vitaminC: Double?        // mg
    var vitaminD: Double?        // µg
    var vitaminB12: Double?      // µg
    var iron: Double?            // mg
    var calcium: Double?         // mg
    var zinc: Double?            // mg

    // Portion
    var portionMultiplier: Double = 1.0  // 1.0 = 100%
    var totalWeight: Double?             // grams
    var totalVolume: Double?             // milliliters
    var familiarUnit: String?            // "1 bowl", "2 cups"

    // Health Assessment
    var healthScore: HealthLevel
    var healthInsights: [String]

    // Allergens & Dietary
    var allergens: [Allergen]
    var dietaryTags: [DietaryTag]

    // Preparation & Context
    var preparationMethod: PreparationMethod?
    var cuisineType: String?
    var mealTags: [String]

    // AI Metadata
    var confidence: ConfidenceLevel
    var uncertaintyNotes: [String]
    var aiProvider: String
    var aiModelVersion: String
    var rawAIResponse: String?
    var processingTimeMs: Int?

    // User Context
    var location: String?
    var activityBefore: ActivityLevel?
    var mood: MoodLevel?

    // Relationships
    @Relationship(deleteRule: .cascade)
    var components: [MealComponent]

    // Computed Properties
    var totalCalories: Double {
        calories * portionMultiplier
    }

    var totalProtein: Double {
        protein * portionMultiplier
    }

    var totalCarbs: Double {
        carbs * portionMultiplier
    }

    var totalFat: Double {
        fat * portionMultiplier
    }

    var hasAllergenWarnings: Bool {
        !allergens.isEmpty
    }
}

// MARK: - Meal Component
@Model
class MealComponent {
    @Attribute(.unique) var id: UUID
    var name: String
    var order: Int  // Display order

    // Quantity (canonical units)
    var quantity: Double        // grams or milliliters
    var unit: CanonicalUnit     // .grams or .milliliters

    // Familiar representation
    var familiarQuantity: Double?
    var familiarUnit: String?  // "cup", "egg", "piece", "tablespoon"

    // Nutrition (per declared quantity)
    var calories: Double
    var protein: Double
    var carbs: Double
    var fat: Double
    var fiber: Double?
    var sugar: Double?
    var saturatedFat: Double?
    var sodium: Double?

    // Component metadata
    var foodCategory: FoodCategory?
    var isLiquid: Bool
    var allergens: [Allergen]
    var dietaryTags: [DietaryTag]

    // AI metadata
    var confidence: ConfidenceLevel
    var uncertaintyNote: String?

    // Portion control
    var isLocked: Bool = false  // Exclude from global portion scaling
    var customMultiplier: Double = 1.0

    // Relationships
    @Relationship(inverse: \\Meal.components)
    var meal: Meal?

    // Computed
    var scaledCalories: Double {
        calories * customMultiplier * (meal?.portionMultiplier ?? 1.0)
    }
}

// MARK: - Daily Goals
@Model
class DailyGoals {
    @Attribute(.unique) var id: UUID
    var lastUpdated: Date
    var source: GoalSource  // manual or wizard

    // Macro Targets
    var calorieTarget: Double
    var proteinTarget: Double
    var carbsTarget: Double
    var fatTarget: Double

    // Optional targets
    var fiberTarget: Double?
    var sugarLimit: Double?
    var sodiumLimit: Double?
    var saturatedFatLimit: Double?

    // Goal context
    var activityLevel: ActivityLevel?
    var goalType: GoalType?  // lose, maintain, gain

    // Wizard inputs (if from wizard)
    var wizardInputs: WizardInputData?

    // User profile
    var age: Int?
    var height: Double?  // cm
    var weight: Double?  // kg
    var gender: Gender?
}

// MARK: - User Preferences
@Model
class UserPreferences {
    @Attribute(.unique) var id: UUID

    // Localization
    var language: String  // "en", "sv", "de"
    var region: String    // "US", "SE", "DE"
    var unitSystem: UnitSystem  // metric, imperial

    // Dietary Restrictions
    var allergens: [Allergen]
    var dietaryPreferences: [DietaryTag]
    var avoidedIngredients: [String]
    var religiousRestrictions: [ReligiousRestriction]

    // App Preferences
    var theme: ThemeMode  // auto, light, dark
    var defaultMealType: MealType?
    var enableHaptics: Bool
    var enableSounds: Bool

    // Privacy
    var enableAnalytics: Bool
    var enableLocationTracking: Bool
    var enableiCloudSync: Bool

    // Subscription
    var subscriptionTier: SubscriptionTier
    var subscriptionExpiry: Date?
}

// MARK: - Favorite Meal
@Model
class FavoriteMeal {
    @Attribute(.unique) var id: UUID
    var name: String
    var templateData: Data  // Encoded Meal structure
    var thumbnailData: Data?
    var lastUsed: Date
    var useCount: Int
    var tags: [String]
}

```

### 4.2 Enums & Supporting Types

```swift
// MARK: - Meal Type
enum MealType: String, Codable {
    case breakfast = "breakfast"
    case lunch = "lunch"
    case dinner = "dinner"
    case snack = "snack"
    case other = "other"

    var localizedName: String {
        switch self {
        case .breakfast: return NSLocalizedString("meal.type.breakfast", comment: "")
        case .lunch: return NSLocalizedString("meal.type.lunch", comment: "")
        case .dinner: return NSLocalizedString("meal.type.dinner", comment: "")
        case .snack: return NSLocalizedString("meal.type.snack", comment: "")
        case .other: return NSLocalizedString("meal.type.other", comment: "")
        }
    }

    var icon: String {
        switch self {
        case .breakfast: return "☕️"
        case .lunch: return "🍽️"
        case .dinner: return "🌙"
        case .snack: return "🍎"
        case .other: return "🍴"
        }
    }
}

// MARK: - Health Level
enum HealthLevel: String, Codable {
    case excellent = "excellent"
    case good = "good"
    case moderate = "moderate"
    case fair = "fair"
    case poor = "poor"
    case unknown = "unknown"

    var color: String {
        switch self {
        case .excellent: return "#059669"
        case .good: return "#10B981"
        case .moderate: return "#F59E0B"
        case .fair: return "#F97316"
        case .poor: return "#EF4444"
        case .unknown: return "#9CA3AF"
        }
    }

    var icon: String {
        switch self {
        case .excellent: return "🟢"
        case .good: return "🟢"
        case .moderate: return "🟡"
        case .fair: return "🟠"
        case .poor: return "🔴"
        case .unknown: return "⚪"
        }
    }

    var localizedName: String {
        switch self {
        case .excellent: return NSLocalizedString("health.level.excellent", comment: "")
        case .good: return NSLocalizedString("health.level.good", comment: "")
        case .moderate: return NSLocalizedString("health.level.moderate", comment: "")
        case .fair: return NSLocalizedString("health.level.fair", comment: "")
        case .poor: return NSLocalizedString("health.level.poor", comment: "")
        case .unknown: return NSLocalizedString("health.level.unknown", comment: "")
        }
    }
}

// MARK: - Confidence Level
enum ConfidenceLevel: String, Codable {
    case high = "high"
    case medium = "medium"
    case low = "low"

    var icon: String {
        switch self {
        case .high: return "checkmark.circle.fill"
        case .medium: return "exclamationmark.circle.fill"
        case .low: return "questionmark.circle.fill"
        }
    }

    var color: String {
        switch self {
        case .high: return "#10B981"
        case .medium: return "#F59E0B"
        case .low: return "#EF4444"
        }
    }

    var localizedName: String {
        switch self {
        case .high: return NSLocalizedString("confidence.high", comment: "")
        case .medium: return NSLocalizedString("confidence.medium", comment: "")
        case .low: return NSLocalizedString("confidence.low", comment: "")
        }
    }
}

// MARK: - Allergens
enum Allergen: String, Codable, CaseIterable {
    case nuts = "nuts"
    case peanuts = "peanuts"
    case dairy = "dairy"
    case eggs = "eggs"
    case soy = "soy"
    case wheat = "wheat"
    case gluten = "gluten"
    case fish = "fish"
    case shellfish = "shellfish"
    case sesame = "sesame"
    case sulfites = "sulfites"
    case mustard = "mustard"
    case celery = "celery"
    case lupin = "lupin"
    case molluscs = "molluscs"

    var icon: String {
        switch self {
        case .nuts: return "🥜"
        case .peanuts: return "🥜"
        case .dairy: return "🥛"
        case .eggs: return "🥚"
        case .soy: return "🫘"
        case .wheat, .gluten: return "🌾"
        case .fish: return "🐟"
        case .shellfish: return "🦐"
        case .sesame: return "🫘"
        case .sulfites: return "⚠️"
        case .mustard: return "🌭"
        case .celery: return "🥬"
        case .lupin: return "🫘"
        case .molluscs: return "🐚"
        }
    }

    var localizedName: String {
        switch self {
        case .nuts: return NSLocalizedString("allergen.nuts", comment: "")
        case .peanuts: return NSLocalizedString("allergen.peanuts", comment: "")
        case .dairy: return NSLocalizedString("allergen.dairy", comment: "")
        case .eggs: return NSLocalizedString("allergen.eggs", comment: "")
        case .soy: return NSLocalizedString("allergen.soy", comment: "")
        case .wheat: return NSLocalizedString("allergen.wheat", comment: "")
        case .gluten: return NSLocalizedString("allergen.gluten", comment: "")
        case .fish: return NSLocalizedString("allergen.fish", comment: "")
        case .shellfish: return NSLocalizedString("allergen.shellfish", comment: "")
        case .sesame: return NSLocalizedString("allergen.sesame", comment: "")
        case .sulfites: return NSLocalizedString("allergen.sulfites", comment: "")
        case .mustard: return NSLocalizedString("allergen.mustard", comment: "")
        case .celery: return NSLocalizedString("allergen.celery", comment: "")
        case .lupin: return NSLocalizedString("allergen.lupin", comment: "")
        case .molluscs: return NSLocalizedString("allergen.molluscs", comment: "")
        }
    }
}

// MARK: - Dietary Tags
enum DietaryTag: String, Codable, CaseIterable {
    case vegetarian = "vegetarian"
    case vegan = "vegan"
    case pescatarian = "pescatarian"
    case glutenFree = "gluten_free"
    case dairyFree = "dairy_free"
    case keto = "keto"
    case paleo = "paleo"
    case lowCarb = "low_carb"
    case highProtein = "high_protein"
    case lowFat = "low_fat"
    case lowSodium = "low_sodium"
    case sugarFree = "sugar_free"
    case organic = "organic"
    case rawFood = "raw_food"

    var icon: String {
        switch self {
        case .vegetarian: return "🥗"
        case .vegan: return "🌱"
        case .pescatarian: return "🐟"
        case .glutenFree: return "🚫🌾"
        case .dairyFree: return "🚫🥛"
        case .keto: return "🥓"
        case .paleo: return "🍖"
        case .lowCarb: return "📉🥖"
        case .highProtein: return "💪"
        case .lowFat: return "📉🧈"
        case .lowSodium: return "📉🧂"
        case .sugarFree: return "🚫🍬"
        case .organic: return "🌿"
        case .rawFood: return "🥕"
        }
    }

    var localizedName: String {
        NSLocalizedString("dietary.\\(rawValue)", comment: "")
    }
}

// MARK: - Religious Restrictions
enum ReligiousRestriction: String, Codable {
    case halal = "halal"
    case kosher = "kosher"
    case hindu = "hindu"
    case jain = "jain"

    var localizedName: String {
        NSLocalizedString("religious.\\(rawValue)", comment: "")
    }
}

// MARK: - Preparation Method
enum PreparationMethod: String, Codable {
    case raw = "raw"
    case cooked = "cooked"
    case boiled = "boiled"
    case steamed = "steamed"
    case fried = "fried"
    case deepFried = "deep_fried"
    case baked = "baked"
    case grilled = "grilled"
    case roasted = "roasted"
    case sauteed = "sauteed"
    case microwaved = "microwaved"
    case airFried = "air_fried"
    case slowCooked = "slow_cooked"
    case pressureCooked = "pressure_cooked"

    var localizedName: String {
        NSLocalizedString("preparation.\\(rawValue)", comment: "")
    }
}

// MARK: - Food Category
enum FoodCategory: String, Codable {
    case vegetable = "vegetable"
    case fruit = "fruit"
    case grain = "grain"
    case protein = "protein"
    case dairy = "dairy"
    case fat = "fat"
    case beverage = "beverage"
    case snack = "snack"
    case condiment = "condiment"
    case sweet = "sweet"
    case processed = "processed"
    case other = "other"

    var localizedName: String {
        NSLocalizedString("category.\\(rawValue)", comment: "")
    }
}

// MARK: - Canonical Units
enum CanonicalUnit: String, Codable {
    case grams = "g"
    case milliliters = "ml"
    case count = "count"

    var localizedName: String {
        switch self {
        case .grams: return NSLocalizedString("unit.grams", comment: "")
        case .milliliters: return NSLocalizedString("unit.milliliters", comment: "")
        case .count: return NSLocalizedString("unit.count", comment: "")
        }
    }
}

// MARK: - Unit System
enum UnitSystem: String, Codable {
    case metric = "metric"
    case imperial = "imperial"

    var localizedName: String {
        switch self {
        case .metric: return NSLocalizedString("units.metric", comment: "")
        case .imperial: return NSLocalizedString("units.imperial", comment: "")
        }
    }
}

// MARK: - Goal Source
enum GoalSource: String, Codable {
    case manual = "manual"
    case wizard = "wizard"

    var localizedName: String {
        switch self {
        case .manual: return NSLocalizedString("goal.source.manual", comment: "")
        case .wizard: return NSLocalizedString("goal.source.wizard", comment: "")
        }
    }
}

// MARK: - Goal Type
enum GoalType: String, Codable {
    case loseFat = "lose_fat"
    case maintain = "maintain"
    case gainMass = "gain_mass"

    var localizedName: String {
        switch self {
        case .loseFat: return NSLocalizedString("goal.type.lose", comment: "")
        case .maintain: return NSLocalizedString("goal.type.maintain", comment: "")
        case .gainMass: return NSLocalizedString("goal.type.gain", comment: "")
        }
    }

    var icon: String {
        switch self {
        case .loseFat: return "📉"
        case .maintain: return "➡️"
        case .gainMass: return "📈"
        }
    }
}

// MARK: - Activity Level
enum ActivityLevel: String, Codable {
    case sedentary = "sedentary"
    case lightlyActive = "lightly_active"
    case moderatelyActive = "moderately_active"
    case veryActive = "very_active"
    case extremelyActive = "extremely_active"

    var localizedName: String {
        NSLocalizedString("activity.\\(rawValue)", comment: "")
    }

    var multiplier: Double {
        switch self {
        case .sedentary: return 1.2
        case .lightlyActive: return 1.375
        case .moderatelyActive: return 1.55
        case .veryActive: return 1.725
        case .extremelyActive: return 1.9
        }
    }
}

// MARK: - Mood Level
enum MoodLevel: String, Codable {
    case excellent = "excellent"
    case good = "good"
    case neutral = "neutral"
    case low = "low"
    case poor = "poor"

    var icon: String {
        switch self {
        case .excellent: return "😄"
        case .good: return "🙂"
        case .neutral: return "😐"
        case .low: return "😕"
        case .poor: return "😞"
        }
    }

    var localizedName: String {
        NSLocalizedString("mood.\\(rawValue)", comment: "")
    }
}

// MARK: - Gender
enum Gender: String, Codable {
    case male = "male"
    case female = "female"
    case other = "other"
    case preferNotToSay = "prefer_not_to_say"

    var localizedName: String {
        NSLocalizedString("gender.\\(rawValue)", comment: "")
    }
}

// MARK: - Theme Mode
enum ThemeMode: String, Codable {
    case auto = "auto"
    case light = "light"
    case dark = "dark"

    var localizedName: String {
        switch self {
        case .auto: return NSLocalizedString("theme.auto", comment: "")
        case .light: return NSLocalizedString("theme.light", comment: "")
        case .dark: return NSLocalizedString("theme.dark", comment: "")
        }
    }
}

// MARK: - Subscription Tier
enum SubscriptionTier: String, Codable {
    case free = "free"
    case premium = "premium"

    var localizedName: String {
        switch self {
        case .free: return NSLocalizedString("subscription.free", comment: "")
        case .premium: return NSLocalizedString("subscription.premium", comment: "")
        }
    }
}

// MARK: - Supporting Data Structures

struct WizardInputData: Codable {
    var activityLevel: ActivityLevel
    var goalType: GoalType
    var age: Int?
    var height: Double?  // cm
    var weight: Double?  // kg
    var gender: Gender?
}

struct NutritionSummary: Codable {
    var calories: Double
    var protein: Double
    var carbs: Double
    var fat: Double
    var fiber: Double?
    var sugar: Double?

    var caloriesFromProtein: Double {
        protein * 4  // 4 calories per gram
    }

    var caloriesFromCarbs: Double {
        carbs * 4
    }

    var caloriesFromFat: Double {
        fat * 9  // 9 calories per gram
    }

    var proteinPercentage: Int {
        guard calories > 0 else { return 0 }
        return Int((caloriesFromProtein / calories) * 100)
    }

    var carbsPercentage: Int {
        guard calories > 0 else { return 0 }
        return Int((caloriesFromCarbs / calories) * 100)
    }

    var fatPercentage: Int {
        guard calories > 0 else { return 0 }
        return Int((caloriesFromFat / calories) * 100)
    }
}

struct DailyProgress: Codable {
    var date: Date
    var consumed: NutritionSummary
    var target: NutritionSummary
    var mealCount: Int

    var calorieProgress: Double {
        guard target.calories > 0 else { return 0 }
        return consumed.calories / target.calories
    }

    var proteinProgress: Double {
        guard target.protein > 0 else { return 0 }
        return consumed.protein / target.protein
    }

    var carbsProgress: Double {
        guard target.carbs > 0 else { return 0 }
        return consumed.carbs / target.carbs
    }

    var fatProgress: Double {
        guard target.fat > 0 else { return 0 }
        return consumed.fat / target.fat
    }

    var isOnTrack: Bool {
        calorieProgress >= 0.8 && calorieProgress <= 1.1
    }
}

```

---

## 5. Localization Strategy

### 5.1 Supported Languages (Phase 1)

- **English (en)** - US, UK, AU
- **Swedish (sv)** - SE
- **German (de)** - DE, AT, CH

### 5.2 Language Detection

The app automatically detects language from:

1. Device system language (primary)
2. User manual selection in settings
3. AI detects input language for voice/text
4. Region-specific defaults

### 5.3 Localization File Structure

```
Resources/
├── Localizable.xcstrings (String Catalog)
├── en.lproj/
│   ├── Localizable.strings
│   └── InfoPlist.strings
├── sv.lproj/
│   ├── Localizable.strings
│   └── InfoPlist.strings
└── de.lproj/
    ├── Localizable.strings
    └── InfoPlist.strings

```

### 5.4 Key Categories

**Navigation & Actions**

```
"nav.back" = "Back" | "Tillbaka" | "Zurück"
"nav.settings" = "Settings" | "Inställningar" | "Einstellungen"
"action.save" = "Save" | "Spara" | "Speichern"
"action.cancel" = "Cancel" | "Avbryt" | "Abbrechen"
"action.delete" = "Delete" | "Radera" | "Löschen"
"action.edit" = "Edit" | "Redigera" | "Bearbeiten"
"action.done" = "Done" | "Klar" | "Fertig"
"action.next" = "Next" | "Nästa" | "Weiter"

```

**Meal Tracking**

```
"meal.add" = "Add meal" | "Lägg till måltid" | "Mahlzeit hinzufügen"
"meal.analyze" = "Analyze" | "Analysera" | "Analysieren"
"meal.update" = "Update meal" | "Uppdatera måltid" | "Mahlzeit aktualisieren"
"meal.calories" = "calories" | "kalorier" | "Kalorien"
"meal.protein" = "Protein" | "Protein" | "Eiweiß"
"meal.carbs" = "Carbs" | "Kolhydrater" | "Kohlenhydrate"
"meal.fat" = "Fat" | "Fett" | "Fett"

```

**Allergens (14 EU Mandatory + Common)**

```
"allergen.nuts" = "Nuts" | "Nötter" | "Nüsse"
"allergen.peanuts" = "Peanuts" | "Jordnötter" | "Erdnüsse"
"allergen.dairy" = "Dairy" | "Mjölk" | "Milchprodukte"
"allergen.eggs" = "Eggs" | "Ägg" | "Eier"
"allergen.gluten" = "Gluten" | "Gluten" | "Gluten"
"allergen.fish" = "Fish" | "Fisk" | "Fisch"
"allergen.shellfish" = "Shellfish" | "Skaldjur" | "Schalentiere"
"allergen.sesame" = "Sesame" | "Sesam" | "Sesam"

```

### 5.5 Number & Unit Formatting

```swift
// NumberFormatter for calories, macros
let calorieFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    formatter.locale = Locale.current
    return formatter
}()

// MeasurementFormatter for weights, volumes
let measurementFormatter: MeasurementFormatter = {
    let formatter = MeasurementFormatter()
    formatter.unitStyle = .medium
    formatter.locale = Locale.current
    return formatter
}()

// Usage examples:
let mass = Measurement(value: 250, unit: UnitMass.grams)
// US: "8.8 oz"
// SE: "250 g"
// DE: "250 g"

```

### 5.6 Date & Time Formatting

```swift
// Relative date formatter for meal timestamps
let relativeFormatter: RelativeDateTimeFormatter = {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .short
    formatter.locale = Locale.current
    return formatter
}()

// Absolute date for calendar
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    formatter.locale = Locale.current
    return formatter
}()

```

---

## 6. Project Structure

### 6.1 Complete File Structure

```
CalSnap/
├── App/
│   ├── CalSnapApp.swift                    # App entry point
│   ├── AppDelegate.swift                   # App lifecycle (if needed)
│   └── Info.plist
│
├── Core/
│   ├── Models/
│   │   ├── Meal.swift                      # @Model class
│   │   ├── MealComponent.swift             # @Model class
│   │   ├── DailyGoals.swift                # @Model class
│   │   ├── UserPreferences.swift           # @Model class
│   │   ├── FavoriteMeal.swift              # @Model class
│   │   ├── Enums/
│   │   │   ├── MealType.swift
│   │   │   ├── HealthLevel.swift
│   │   │   ├── ConfidenceLevel.swift
│   │   │   ├── Allergen.swift
│   │   │   ├── DietaryTag.swift
│   │   │   ├── ActivityLevel.swift
│   │   │   ├── GoalType.swift
│   │   │   └── PreparationMethod.swift
│   │   └── Supporting/
│   │       ├── NutritionSummary.swift
│   │       ├── DailyProgress.swift
│   │       └── WizardInputData.swift
│   │
│   ├── Services/
│   │   ├── AIService/
│   │   │   ├── AIServiceProtocol.swift      # Protocol definition
│   │   │   ├── GeminiAIService.swift        # Gemini implementation
│   │   │   ├── MockAIService.swift          # For testing
│   │   │   └── Models/
│   │   │       ├── AIRequest.swift
│   │   │       ├── AIResponse.swift
│   │   │       └── AIError.swift
│   │   │
│   │   ├── PersistenceService/
│   │   │   ├── PersistenceService.swift     # SwiftData container
│   │   │   ├── CloudKitService.swift        # iCloud sync
│   │   │   └── DataExportService.swift      # Export functionality
│   │   │
│   │   ├── UnitConversionService/
│   │   │   ├── UnitConversionService.swift  # Main service
│   │   │   ├── FamiliarUnitRegistry.swift   # Unit definitions
│   │   │   └── RegionConversions.swift      # Region-specific
│   │   │
│   │   ├── ImageService/
│   │   │   ├── ImageService.swift           # Compression, resizing
│   │   │   └── ThumbnailGenerator.swift     # Thumbnail creation
│   │   │
│   │   ├── SubscriptionService/
│   │   │   ├── SubscriptionService.swift    # StoreKit 2
│   │   │   ├── SubscriptionManager.swift    # State management
│   │   │   └── Products.storekit            # Product config
│   │   │
│   │   ├── NetworkService/
│   │   │   ├── NetworkService.swift         # HTTP client
│   │   │   ├── APIEndpoints.swift           # Endpoint definitions
│   │   │   └── NetworkError.swift           # Error handling
│   │   │
│   │   └── LocalizationService/
│   │       ├── LocalizationService.swift    # Language management
│   │       └── RegionService.swift          # Region-specific logic
│   │
│   └── Utilities/
│       ├── Extensions/
│       │   ├── Date+Extensions.swift
│       │   ├── Double+Extensions.swift
│       │   ├── String+Extensions.swift
│       │   ├── Color+Extensions.swift
│       │   └── View+Extensions.swift
│       │
│       ├── Helpers/
│       │   ├── HapticManager.swift
│       │   ├── SoundManager.swift
│       │   ├── ValidationHelper.swift
│       │   └── DateHelper.swift
│       │
│       └── Constants/
│           ├── AppConstants.swift
│           ├── APIConstants.swift
│           └── LayoutConstants.swift
│
├── Features/
│   ├── Home/
│   │   ├── Views/
│   │   │   ├── HomeView.swift               # Main screen
│   │   │   ├── WeekCalendarView.swift       # Week scroll
│   │   │   ├── DailyProgressCard.swift      # Progress display
│   │   │   ├── MealCardView.swift           # Meal list item
│   │   │   └── InputBarView.swift           # Bottom input
│   │   │
│   │   └── ViewModels/
│   │       ├── HomeViewModel.swift
│   │       └── DailyProgressViewModel.swift
│   │
│   ├── MealDetail/
│   │   ├── Views/
│   │   │   ├── MealDetailView.swift         # Main detail screen
│   │   │   ├── MealHeaderView.swift         # Hero image + calories
│   │   │   ├── MacroPillsView.swift         # Macro indicators
│   │   │   ├── PortionControlView.swift     # Slider control
│   │   │   ├── HealthInsightsCard.swift     # Health info + allergens
│   │   │   ├── AllergenBadgeView.swift      # Allergen warnings
│   │   │   ├── ComponentListView.swift      # Ingredients list
│   │   │   ├── ComponentCardView.swift      # Individual component
│   │   │   └── MealUpdateBarView.swift      # Update input
│   │   │
│   │   └── ViewModels/
│   │       ├── MealDetailViewModel.swift
│   │       └── ComponentViewModel.swift
│   │
│   ├── Camera/
│   │   ├── Views/
│   │   │   ├── CameraView.swift             # Camera interface
│   │   │   ├── CameraPreviewView.swift      # Live preview
│   │   │   ├── PhotoThumbnailView.swift     # Image thumbnails
│   │   │   └── AnalysisLoadingView.swift    # Processing state
│   │   │
│   │   ├── ViewModels/
│   │   │   └── CameraViewModel.swift
│   │   │
│   │   └── Controllers/
│   │       └── CameraController.swift       # AVFoundation logic
│   │
│   ├── Settings/
│   │   ├── Views/
│   │   │   ├── SettingsView.swift           # Main settings
│   │   │   ├── GoalsSettingsView.swift      # Goals configuration
│   │   │   ├── AllergenSettingsView.swift   # Allergen selection
│   │   │   ├── PreferencesView.swift        # App preferences
│   │   │   ├── PrivacyView.swift            # Privacy settings
│   │   │   └── SubscriptionView.swift       # Subscription management
│   │   │
│   │   └── ViewModels/
│   │       ├── SettingsViewModel.swift
│   │       └── SubscriptionViewModel.swift
│   │
│   ├── GoalWizard/
│   │   ├── Views/
│   │   │   ├── GoalWizardView.swift         # Main wizard flow
│   │   │   ├── ActivityLevelView.swift      # Step 1
│   │   │   ├── GoalSelectionView.swift      # Step 2
│   │   │   ├── BodyMetricsView.swift        # Step 3
│   │   │   └── RecommendationView.swift     # Step 4
│   │   │
│   │   └── ViewModels/
│   │       └── GoalWizardViewModel.swift
│   │
│   └── Favorites/
│       ├── Views/
│       │   ├── FavoritesView.swift          # Favorites list
│       │   └── FavoriteCardView.swift       # Favorite item
│       │
│       └── ViewModels/
│           └── FavoritesViewModel.swift
│
├── DesignSystem/
│   ├── Theme/
│   │   ├── AppTheme.swift                   # Central theme config
│   │   ├── ColorPalette.swift               # All colors
│   │   ├── Typography.swift                 # Font styles
│   │   ├── Spacing.swift                    # Spacing system
│   │   ├── Shadows.swift                    # Shadow definitions
│   │   └── CornerRadius.swift               # Radius values
│   │
│   ├── Components/
│   │   ├── Buttons/
│   │   │   ├── PrimaryButton.swift          # Main action button
│   │   │   ├── SecondaryButton.swift        # Secondary actions
│   │   │   ├── IconButton.swift             # Icon-only button
│   │   │   └── TextButton.swift             # Text-only button
│   │   │
│   │   ├── Cards/
│   │   │   ├── BaseCard.swift               # Reusable card container
│   │   │   ├── ProgressCard.swift           # Daily progress display
│   │   │   ├── InfoCard.swift               # Info/insights display
│   │   │   └── SelectionCard.swift          # Selectable card
│   │   │
│   │   ├── Input/
│   │   │   ├── TextInputField.swift         # Text input
│   │   │   ├── SliderControl.swift          # Custom slider
│   │   │   ├── VoiceInputButton.swift       # Voice recording
│   │   │   └── SearchBar.swift              # Search input
│   │   │
│   │   ├── Display/
│   │   │   ├── ProgressBar.swift            # Progress indicator
│   │   │   ├── MacroPill.swift              # Macro display pill
│   │   │   ├── Badge.swift                  # Status badge
│   │   │   ├── AllergenBadge.swift          # Allergen warning
│   │   │   └── HealthBadge.swift            # Health score indicator
│   │   │
│   │   ├── Lists/
│   │   │   ├── MealListItem.swift           # Meal card for list
│   │   │   ├── ComponentListItem.swift      # Component card
│   │   │   └── SettingsListItem.swift       # Settings row
│   │   │
│   │   └── Common/
│   │       ├── LoadingView.swift            # Loading spinner
│   │       ├── EmptyStateView.swift         # Empty state placeholder
│   │       ├── ErrorView.swift              # Error display
│   │       ├── DividerLine.swift            # Custom divider
│   │       └── ImageView.swift              # Async image loader
│   │
│   └── Modifiers/
│       ├── CardModifier.swift               # Card styling
│       ├── ShadowModifier.swift             # Shadow effects
│       ├── HapticModifier.swift             # Haptic feedback
│       └── ShimmerModifier.swift            # Loading shimmer
│
├── Resources/
│   ├── Localization/
│   │   ├── en.lproj/
│   │   │   └── Localizable.strings
│   │   ├── sv.lproj/
│   │   │   └── Localizable.strings
│   │   └── de.lproj/
│   │       └── Localizable.strings
│   │
│   ├── Assets.xcassets/
│   │   ├── Colors/
│   │   │   ├── Primary.colorset
│   │   │   ├── Secondary.colorset
│   │   │   └── Semantic.colorset
│   │   │
│   │   ├── Icons/
│   │   │   ├── Camera.imageset
│   │   │   ├── Settings.imageset
│   │   │   └── Health.imageset
│   │   │
│   │   └── AppIcon.appiconset
│   │
│   └── Sounds/
│       ├── success.wav
│       └── error.wav
│
├── Tests/
│   ├── UnitTests/
│   │   ├── ModelTests/
│   │   │   ├── MealTests.swift
│   │   │   └── DailyGoalsTests.swift
│   │   │
│   │   ├── ServiceTests/
│   │   │   ├── AIServiceTests.swift
│   │   │   ├── UnitConversionTests.swift
│   │   │   └── PersistenceTests.swift
│   │   │
│   │   └── ViewModelTests/
│   │       ├── HomeViewModelTests.swift
│   │       └── MealDetailViewModelTests.swift
│   │
│   └── UITests/
│       ├── HomeViewTests.swift
│       ├── MealDetailTests.swift
│       └── CameraFlowTests.swift
│
└── Documentation/
    ├── README.md                            # Project overview
    ├── DESIGN_SYSTEM.md                     # Design guidelines
    ├── API_SCHEMA.md                        # AI API contract
    ├── LOCALIZATION.md                      # Translation guide
    ├── ARCHITECTURE.md                      # Technical architecture
    └── CONTRIBUTING.md                      # Development guide

```

### 6.2 File Purposes & Responsibilities

### App Layer

- **CalSnapApp.swift**: SwiftUI app entry, initialize services, configure environment
- **AppDelegate.swift**: Handle push notifications, background tasks (if needed)

### Core/Models

- **Meal.swift**: Main meal entity with all nutrition data
- **MealComponent.swift**: Individual food items within meals
- **DailyGoals.swift**: User's daily nutrition targets
- **UserPreferences.swift**: App settings and user preferences
- **FavoriteMeal.swift**: Saved meal templates

### Core/Services

- **AIServiceProtocol.swift**: Abstract AI interface for testability
- **GeminiAIService.swift**: Concrete Gemini API implementation
- **PersistenceService.swift**: SwiftData + CloudKit wrapper
- **UnitConversionService.swift**: Convert between metric/imperial/familiar units
- **ImageService.swift**: Image compression, thumbnail generation
- **SubscriptionService.swift**: StoreKit 2 integration
- **NetworkService.swift**: HTTP client for backend API

### Features/[Feature]

Each feature follows the same structure:

- **Views/**: SwiftUI views for UI
- **ViewModels/**: Observable view models (MVVM)
- **Controllers/**: Platform-specific controllers (AVFoundation, etc.)

### DesignSystem

- **Theme/**: Centralized styling configuration
- **Components/**: Reusable UI components
- **Modifiers/**: Custom view modifiers

---

## 7. Reusable UI Components

### 7.1 Button Components

### PrimaryButton.swift

```swift
struct PrimaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.xs) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    if let icon = icon {
                        Image(systemName: icon)
                    }
                    Text(title)
                        .font(AppTheme.Typography.bodyMedium)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(isDisabled ? AppTheme.Colors.gray : AppTheme.Colors.primary)
            .foregroundColor(.white)
            .cornerRadius(AppTheme.CornerRadius.md)
            .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
        }
        .disabled(isDisabled || isLoading)
    }
}

```

### IconButton.swift

```swift
struct IconButton: View {
    let icon: String
    let size: CGFloat
    let action: () -> Void
    var color: Color = AppTheme.Colors.primary

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size))
                .foregroundColor(color)
                .frame(width: size * 1.5, height: size * 1.5)
        }
        .hapticFeedback()
    }
}

```

### 7.2 Card Components

### BaseCard.swift

```swift
struct BaseCard<Content: View>: View {
    let content: Content
    var padding: CGFloat = AppTheme.Spacing.md
    var shadow: Bool = true

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.CornerRadius.lg)
            .shadow(
                color: shadow ? .black.opacity(0.08) : .clear,
                radius: 8,
                y: 2
            )
    }
}

```

### ProgressCard.swift

```swift
struct ProgressCard: View {
    let current: Double
    let target: Double
    let label: String
    let color: Color

    var progress: Double {
        guard target > 0 else { return 0 }
        return min(current / target, 1.0)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            HStack {
                Text(label)
                    .font(AppTheme.Typography.captionLarge)
                    .foregroundColor(AppTheme.Colors.textSecondary)

                Spacer()

                Text("\\(Int(progress * 100))%")
                    .font(AppTheme.Typography.captionLarge)
                    .foregroundColor(color)
            }

            HStack(spacing: AppTheme.Spacing.xs) {
                Text("\\(Int(current))")
                    .font(AppTheme.Typography.numberMedium)
                    .foregroundColor(AppTheme.Colors.textPrimary)

                Text("/")
                    .foregroundColor(AppTheme.Colors.textSecondary)

                Text("\\(Int(target))")
                    .font(AppTheme.Typography.bodySmall)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }

            ProgressBar(progress: progress, color: color)
        }
    }
}

```

### 7.3 Display Components

### ProgressBar.swift

```swift
struct ProgressBar: View {
    let progress: Double  // 0.0 to 1.0
    let color: Color
    var height: CGFloat = 8

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(AppTheme.Colors.progressBackground)

                // Foreground
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(color)
                    .frame(width: geometry.size.width * CGFloat(progress))
                    .animation(.spring(duration: 0.5), value: progress)
            }
        }
        .frame(height: height)
    }
}

```

### MacroPill.swift

```swift
struct MacroPill: View {
    let icon: String
    let label: String
    let value: Int
    let color: Color

    var body: some View {
        VStack(spacing: AppTheme.Spacing.xxs) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)

            Text("\\(value)")
                .font(AppTheme.Typography.numberMedium)
                .foregroundColor(AppTheme.Colors.textPrimary)

            Text(label)
                .font(AppTheme.Typography.captionSmall)
                .foregroundColor(AppTheme.Colors.textSecondary)
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppTheme.Spacing.sm)
        .background(color.opacity(0.1))
        .cornerRadius(AppTheme.CornerRadius.md)
    }
}

```

### AllergenBadge.swift

```swift
struct AllergenBadge: View {
    let allergen: Allergen
    var showIcon: Bool = true

    var body: some View {
        HStack(spacing: AppTheme.Spacing.xxs) {
            if showIcon {
                Text(allergen.icon)
                    .font(.system(size: 16))
            }

            Text(allergen.localizedName)
                .font(AppTheme.Typography.captionSmall)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, AppTheme.Spacing.sm)
        .padding(.vertical, AppTheme.Spacing.xxs)
        .background(AppTheme.Colors.warningBackground)
        .foregroundColor(AppTheme.Colors.warningText)
        .cornerRadius(AppTheme.CornerRadius.sm)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.sm)
                .stroke(AppTheme.Colors.warning, lineWidth: 1)
        )
    }
}

```

### HealthBadge.swift

```swift
struct HealthBadge: View {
    let level: HealthLevel
    var size: CGFloat = 24

    var body: some View {
        Text(level.icon)
            .font(.system(size: size))
            .frame(width: size * 1.2, height: size * 1.2)
            .background(
                Circle()
                    .fill(Color(hex: level.color).opacity(0.2))
            )
    }
}

```

### 7.4 Input Components

### SliderControl.swift

```swift
struct SliderControl: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double?
    let label: String
    let unit: String
    var hapticSteps: [Double] = []

    @State private var lastHapticValue: Double = 0

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            HStack {
                Text(label)
                    .font(AppTheme.Typography.bodySmall)
                    .foregroundColor(AppTheme.Colors.textSecondary)

                Spacer()

                Text("\\(Int(value)) \\(unit)")
                    .font(AppTheme.Typography.numberSmall)
                    .foregroundColor(AppTheme.Colors.textPrimary)
            }

            Slider(
                value: $value,
                in: range,
                step: step ?? 1
            )
            .tint(AppTheme.Colors.primary)
            .onChange(of: value) { oldValue, newValue in
                // Haptic feedback at specific values
                for hapticValue in hapticSteps {
                    if abs(newValue - hapticValue) < 0.01 && abs(lastHapticValue - hapticValue) > 0.01 {
                        HapticManager.shared.impact(style: .medium)
                        lastHapticValue = newValue
                    }
                }
            }
        }
    }
}

```

### VoiceInputButton.swift

```swift
struct VoiceInputButton: View {
    @Binding var isRecording: Bool
    let onStartRecording: () -> Void
    let onStopRecording: () -> Void

    @State private var pulseAnimation = false

    var body: some View {
        Button(action: {
            if isRecording {
                onStopRecording()
            } else {
                onStartRecording()
            }
        }) {
            Image(systemName: isRecording ? "mic.fill" : "mic")
                .font(.system(size: 20))
                .foregroundColor(isRecording ? .red : AppTheme.Colors.textSecondary)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(isRecording ? Color.red.opacity(0.1) : Color.clear)
                        .scaleEffect(pulseAnimation ? 1.2 : 1.0)
                        .animation(
                            isRecording ? .easeInOut(duration: 0.8).repeatForever(autoreverses: true) : .default,
                            value: pulseAnimation
                        )
                )
        }
        .onChange(of: isRecording) { _, newValue in
            pulseAnimation = newValue
        }
    }
}

```

### 7.5 List Components

### MealListItem.swift

```swift
struct MealListItem: View {
    let meal: Meal
    let onTap: () -> Void
    let onDelete: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AppTheme.Spacing.sm) {
                // Thumbnail
                if let imageData = meal.thumbnailData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 64, height: 64)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.sm))
                } else {
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.sm)
                        .fill(AppTheme.Colors.imagePlaceholder)
                        .frame(width: 64, height: 64)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(AppTheme.Colors.textTertiary)
                        )
                }

                // Content
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xxs) {
                    Text(meal.name)
                        .font(AppTheme.Typography.bodyMedium)
                        .fontWeight(.semibold)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                        .lineLimit(1)

                    Text("\\(Int(meal.totalCalories)) kcal • P:\\(Int(meal.totalProtein)) C:\\(Int(meal.totalCarbs)) F:\\(Int(meal.totalFat))")
                        .font(AppTheme.Typography.captionSmall)
                        .foregroundColor(AppTheme.Colors.textSecondary)

                    Text(meal.timestamp.formatted(date: .omitted, time: .shortened))
                        .font(AppTheme.Typography.captionTiny)
                        .foregroundColor(AppTheme.Colors.textTertiary)
                }

                Spacer()

                // Health badge
                HealthBadge(level: meal.healthScore)
            }
            .padding(AppTheme.Spacing.sm)
            .background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.CornerRadius.md)
            .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
        }
        .buttonStyle(.plain)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive, action: onDelete) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

```

### ComponentListItem.swift

```swift
struct ComponentListItem: View {
    @Binding var component: MealComponent
    let onDelete: () -> Void

    var body: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            // Header
            HStack {
                Text(component.name)
                    .font(AppTheme.Typography.bodyMedium)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.Colors.textPrimary)

                Spacer()

                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(AppTheme.Colors.destructive)
                }
            }

            // Quantity
            HStack {
                if let familiarUnit = component.familiarUnit,
                   let familiarQty = component.familiarQuantity {
                    Text("\\(Int(familiarQty)) \\(familiarUnit)")
                        .font(AppTheme.Typography.captionLarge)
                }

                Text("VIKT \\(Int(component.quantity)) G")
                    .font(AppTheme.Typography.captionSmall)
                    .foregroundColor(AppTheme.Colors.textSecondary)

                Spacer()
            }

            // Slider
            SliderControl(
                value: $component.customMultiplier,
                range: 0.25...2.0,
                step: 0.05,
                label: "",
                unit: "%",
                hapticSteps: [0.5, 1.0, 1.5, 2.0]
            )

            // Macros
            HStack(spacing: AppTheme.Spacing.md) {
                MacroIndicator(
                    icon: "🔥",
                    value: Int(component.scaledCalories),
                    color: AppTheme.Colors.calories
                )
                MacroIndicator(
                    icon: "💪",
                    value: Int(component.protein * component.customMultiplier),
                    color: AppTheme.Colors.protein
                )
                MacroIndicator(
                    icon: "🥦",
                    value: Int(component.carbs * component.customMultiplier),
                    color: AppTheme.Colors.carbs
                )
                MacroIndicator(
                    icon: "💧",
                    value: Int(component.fat * component.customMultiplier),
                    color: AppTheme.Colors.fat
                )
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(AppTheme.Colors.componentBackground)
        .cornerRadius(AppTheme.CornerRadius.md)
    }
}

struct MacroIndicator: View {
    let icon: String
    let value: Int
    let color: Color

    var body: some View {
        HStack(spacing: 4) {
            Text(icon)
                .font(.system(size: 14))
            Text("\\(value)")
                .font(AppTheme.Typography.captionSmall)
                .foregroundColor(color)
                .fontWeight(.semibold)
        }
    }
}

```

### 7.6 Common Components

### LoadingView.swift

```swift
struct LoadingView: View {
    let message: String

    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(AppTheme.Colors.primary)

            Text(message)
                .font(AppTheme.Typography.bodySmall)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.Colors.background.opacity(0.9))
    }
}

```

### EmptyStateView.swift

```swift
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?

    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(AppTheme.Colors.textTertiary)

            VStack(spacing: AppTheme.Spacing.xs) {
                Text(title)
                    .font(AppTheme.Typography.heading2)
                    .foregroundColor(AppTheme.Colors.textPrimary)

                Text(message)
                    .font(AppTheme.Typography.bodySmall)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }

            if let actionTitle = actionTitle, let action = action {
                PrimaryButton(
                    title: actionTitle,
                    icon: nil,
                    action: action
                )
                .frame(maxWidth: 200)
            }
        }
        .padding(AppTheme.Spacing.xl)
    }
}

```

### 7.7 View Modifiers

### CardModifier.swift

```swift
struct CardModifier: ViewModifier {
    var padding: CGFloat = AppTheme.Spacing.md
    var shadow: Bool = true

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.CornerRadius.lg)
            .shadow(
                color: shadow ? .black.opacity(0.08) : .clear,
                radius: 8,
                y: 2
            )
    }
}

extension View {
    func cardStyle(padding: CGFloat = AppTheme.Spacing.md, shadow: Bool = true) -> some View {
        modifier(CardModifier(padding: padding, shadow: shadow))
    }
}

```

### HapticModifier.swift

```swift
struct HapticModifier: ViewModifier {
    let style: UIImpactFeedbackGenerator.FeedbackStyle

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                TapGesture()
                    .onEnded { _ in
                        HapticManager.shared.impact(style: style)
                    }
            )
    }
}

extension View {
    func hapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .light) -> some View {
        modifier(HapticModifier(style: style))
    }
}

```

---

## 8. Implementation Guide

### 8.1 Development Setup

### Prerequisites

```bash
# Xcode 16+
# iOS 17.0+ target
# CocoaPods or SPM for dependencies (minimal)

```

### Environment Configuration

```swift
// AppConstants.swift
enum Environment {
    static let apiBaseURL: String = {
        #if DEBUG
        return "<https://dev-api.calsnap.app>"
        #else
        return "<https://api.calsnap.app>"
        #endif
    }()

    static let geminiModel = "gemini-2.0-flash-exp"
    static let maxPhotosPerMeal = 5
    static let thumbnailSize = CGSize(width: 128, height: 128)
    static let imageQuality: CGFloat = 0.8
}

```

### 8.2 Architecture Overview

```
┌──────────────────────────────────────┐
│           SwiftUI Views              │
│   (Declarative UI, State-driven)     │
└──────────────┬───────────────────────┘
               │
               ▼
┌──────────────────────────────────────┐
│          View Models                 │
│   (@Observable, Business Logic)      │
└──────────────┬───────────────────────┘
               │
               ▼
┌──────────────────────────────────────┐
│          Services Layer              │
│   (AI, Persistence, Network, etc.)   │
└──────────────┬───────────────────────┘
               │
               ▼
┌──────────────────────────────────────┐
│        Data Models                   │
│   (SwiftData, Codable structs)       │
└──────────────────────────────────────┘

```

### 8.3 Key Implementation Patterns

### MVVM with SwiftUI

```swift
// ViewModel
@Observable
class MealDetailViewModel {
    var meal: Meal
    var isLoading = false
    var errorMessage: String?

    private let aiService: AIServiceProtocol
    private let persistenceService: PersistenceService

    init(meal: Meal,
         aiService: AIServiceProtocol,
         persistenceService: PersistenceService) {
        self.meal = meal
        self.aiService = aiService
        self.persistenceService = persistenceService
    }

    func updateMeal(with input: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let updatedMeal = try await aiService.updateMeal(meal, input: input)
            meal = updatedMeal
            try persistenceService.save(meal)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

// View
struct MealDetailView: View {
    @State private var viewModel: MealDetailViewModel

    var body: some View {
        ScrollView {
            // UI using viewModel.meal
        }
        .overlay {
            if viewModel.isLoading {
                LoadingView(message: "Updating meal...")
            }
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
    }
}

```

### Protocol-Oriented Services

```swift
// Protocol
protocol AIServiceProtocol {
    func analyzeMeal(images: [Data], text: String?, context: AnalysisContext) async throws -> Meal
    func updateMeal(_ meal: Meal, input: String) async throws -> Meal
}

// Implementation
class GeminiAIService: AIServiceProtocol {
    private let networkService: NetworkService
    private let endpoint = "/v1/analyze"

    func analyzeMeal(images: [Data], text: String?, context: AnalysisContext) async throws -> Meal {
        let request = AIRequest(images: images, text: text, context: context)
        let response: AIResponse = try await networkService.post(endpoint, body: request)
        return response.toMeal()
    }
}

// Mock for testing
class MockAIService: AIServiceProtocol {
    func analyzeMeal(images: [Data], text: String?, context: AnalysisContext) async throws -> Meal {
        // Return mock data
        return Meal.mockBreakfast
    }
}

```

### 8.4 AI Integration Flow

`User captures photo
        │
        ▼
CameraViewModel compresses image
        │
        ▼
NetworkService sends to backend
        │
        ▼
Backend validates subscription
        │
        ▼
Backend calls Gemini API
        │
        ▼
Backend returns structured JSON
        │
        ▼
AIService parses to Meal model
        │
        ▼
PersistenceService saves locally
        │
        ▼
UI updates`

### Backend Request/Response Example

**Request:**

json

`{
  "images": ["base64_encoded_image_data"],
  "text": "Greek yogurt with berries",
  "context": {
    "language": "en",
    "unitSystem": "metric",
    "region": "US",
    "timestamp": "2025-12-28T10:30:00Z",
    "timezone": "America/New_York"
  }
}`

**Response:**

json

`{
  "meal": {
    "name": "Greek Yogurt with Berries",
    "summary": "Plain Greek yogurt topped with mixed berries",
    "totalCalories": 348,
    "totalProtein": 9.0,
    "totalCarbs": 28.0,
    "totalFat": 21.0,
    "fiber": 4.0,
    "sugar": 18.0,
    "sodium": 85.0,
    "portionInfo": {
      "estimatedWeight": 250,
      "weightUnit": "g",
      "familiarDescription": "1 bowl",
      "confidence": "high"
    },
    "healthAssessment": {
      "level": "good",
      "insights": [
        "High in protein",
        "Good source of probiotics",
        "Contains natural sugars from fruit"
      ],
      "overallConfidence": "high"
    },
    "components": [
      {
        "name": "Greek yogurt",
        "quantity": 200,
        "unit": "g",
        "familiarQuantity": 0.85,
        "familiarUnit": "cup",
        "calories": 260,
        "protein": 20.0,
        "carbs": 10.0,
        "fat": 18.0,
        "confidence": "high",
        "allergens": ["dairy"]
      },
      {
        "name": "Mixed berries",
        "quantity": 50,
        "unit": "g",
        "familiarQuantity": 0.3,
        "familiarUnit": "cup",
        "calories": 28,
        "protein": 0.5,
        "carbs": 7.0,
        "fat": 0.2,
        "confidence": "medium",
        "uncertaintyNote": "Exact berry composition unclear"
      }
    ],
    "allergens": ["dairy"],
    "dietaryTags": ["vegetarian", "gluten_free"],
    "uncertainties": [
      "Exact yogurt fat content assumed (full-fat)",
      "Berry portion estimated visually"
    ],
    "metadata": {
      "analysisTimestamp": "2025-12-28T10:30:15Z",
      "modelVersion": "gemini-2.0-flash-exp",
      "processingTimeMs": 1240
    }
  }
}`

### 8.5 SwiftData + iCloud Sync

### Container Setup

swift

`// PersistenceService.swift
import SwiftData
import CloudKit

@MainActor
class PersistenceService {
    static let shared = PersistenceService()
    
    let container: ModelContainer
    let context: ModelContext
    
    private init() {
        let schema = Schema([
            Meal.self,
            MealComponent.self,
            DailyGoals.self,
            UserPreferences.self,
            FavoriteMeal.self
        ])
        
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .automatic
        )
        
        do {
            container = try ModelContainer(for: schema, configurations: [configuration])
            context = ModelContext(container)
            context.autosaveEnabled = true
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    // MARK: - CRUD Operations
    
    func save<T: PersistentModel>(_ model: T) throws {
        context.insert(model)
        try context.save()
    }
    
    func delete<T: PersistentModel>(_ model: T) throws {
        context.delete(model)
        try context.save()
    }
    
    func fetch<T: PersistentModel>(
        _ type: T.Type,
        predicate: Predicate<T>? = nil,
        sortBy: [SortDescriptor<T>] = []
    ) throws -> [T] {
        var descriptor = FetchDescriptor<T>(predicate: predicate, sortBy: sortBy)
        return try context.fetch(descriptor)
    }
    
    // MARK: - Meal Queries
    
    func mealsForDate(_ date: Date) throws -> [Meal] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = #Predicate<Meal> { meal in
            meal.timestamp >= startOfDay && meal.timestamp < endOfDay
        }
        
        return try fetch(
            Meal.self,
            predicate: predicate,
            sortBy: [SortDescriptor(\.timestamp, order: .forward)]
        )
    }
    
    func dailyProgress(for date: Date, goals: DailyGoals) throws -> DailyProgress {
        let meals = try mealsForDate(date)
        
        let consumed = NutritionSummary(
            calories: meals.reduce(0) { $0 + $1.totalCalories },
            protein: meals.reduce(0) { $0 + $1.totalProtein },
            carbs: meals.reduce(0) { $0 + $1.totalCarbs },
            fat: meals.reduce(0) { $0 + $1.totalFat },
            fiber: meals.compactMap { $0.fiber }.reduce(0, +),
            sugar: meals.compactMap { $0.sugar }.reduce(0, +)
        )
        
        let target = NutritionSummary(
            calories: goals.calorieTarget,
            protein: goals.proteinTarget,
            carbs: goals.carbsTarget,
            fat: goals.fatTarget,
            fiber: goals.fiberTarget,
            sugar: goals.sugarLimit
        )
        
        return DailyProgress(
            date: date,
            consumed: consumed,
            target: target,
            mealCount: meals.count
        )
    }
}`

### 8.6 Unit Conversion System

swift

`// UnitConversionService.swift
class UnitConversionService {
    
    static let shared = UnitConversionService()
    
    // MARK: - Familiar Unit Registry
    
    struct FamiliarUnitDefinition {
        let name: String
        let category: UnitCategory
        let gramsPerUnit: Double?
        let mlPerUnit: Double?
    }
    
    enum UnitCategory {
        case volume
        case weight
        case count
    }
    
    private let familiarUnits: [String: FamiliarUnitDefinition] = [
        // Volume
        "cup": FamiliarUnitDefinition(name: "cup", category: .volume, gramsPerUnit: nil, mlPerUnit: 240),
        "tablespoon": FamiliarUnitDefinition(name: "tablespoon", category: .volume, gramsPerUnit: nil, mlPerUnit: 15),
        "teaspoon": FamiliarUnitDefinition(name: "teaspoon", category: .volume, gramsPerUnit: nil, mlPerUnit: 5),
        "glass": FamiliarUnitDefinition(name: "glass", category: .volume, gramsPerUnit: nil, mlPerUnit: 250),
        
        // Weight
        "oz": FamiliarUnitDefinition(name: "oz", category: .weight, gramsPerUnit: 28.35, mlPerUnit: nil),
        "lb": FamiliarUnitDefinition(name: "lb", category: .weight, gramsPerUnit: 453.592, mlPerUnit: nil),
        
        // Count (with standard weights)
        "egg": FamiliarUnitDefinition(name: "egg", category: .count, gramsPerUnit: 60, mlPerUnit: nil),
        "apple": FamiliarUnitDefinition(name: "apple", category: .count, gramsPerUnit: 182, mlPerUnit: nil),
        "banana": FamiliarUnitDefinition(name: "banana", category: .count, gramsPerUnit: 120, mlPerUnit: nil),
        "slice_bread": FamiliarUnitDefinition(name: "slice", category: .count, gramsPerUnit: 30, mlPerUnit: nil),
    ]
    
    // MARK: - Conversion Functions
    
    func convertToCanonical(
        value: Double,
        fromUnit: String,
        foodItem: String? = nil
    ) -> (grams: Double?, milliliters: Double?) {
        guard let unitDef = familiarUnits[fromUnit] else {
            return (nil, nil)
        }
        
        switch unitDef.category {
        case .weight:
            return (value * (unitDef.gramsPerUnit ?? 0), nil)
        case .volume:
            return (nil, value * (unitDef.mlPerUnit ?? 0))
        case .count:
            return (value * (unitDef.gramsPerUnit ?? 0), nil)
        }
    }
    
    func convertFromCanonical(
        grams: Double?,
        milliliters: Double?,
        toUnit: String,
        foodItem: String? = nil
    ) -> Double? {
        guard let unitDef = familiarUnits[toUnit] else {
            return nil
        }
        
        switch unitDef.category {
        case .weight:
            guard let grams = grams, let gramsPerUnit = unitDef.gramsPerUnit else { return nil }
            return grams / gramsPerUnit
        case .volume:
            guard let ml = milliliters, let mlPerUnit = unitDef.mlPerUnit else { return nil }
            return ml / mlPerUnit
        case .count:
            guard let grams = grams, let gramsPerUnit = unitDef.gramsPerUnit else { return nil }
            return grams / gramsPerUnit
        }
    }
    
    func suggestFamiliarUnit(
        for grams: Double?,
        milliliters: Double?,
        foodItem: String,
        userRegion: String
    ) -> (quantity: Double, unit: String)? {
        // Context-aware suggestions based on food type and region
        
        // Example: Rice
        if foodItem.lowercased().contains("rice") {
            if let g = grams {
                let cups = g / 185.0  // 1 cup cooked rice ≈ 185g
                if cups > 0.5 && cups < 3 {
                    return (cups, "cup")
                }
            }
        }
        
        // Example: Liquids
        if foodItem.lowercased().contains("water") || foodItem.lowercased().contains("milk") {
            if let ml = milliliters {
                if userRegion == "US" {
                    let cups = ml / 240.0
                    if cups > 0.5 && cups < 4 {
                        return (cups, "cup")
                    }
                } else {
                    return (ml, "ml")
                }
            }
        }
        
        // Fallback to canonical
        if let g = grams {
            return (g, "g")
        } else if let ml = milliliters {
            return (ml, "ml")
        }
        
        return nil
    }
}`

### 8.7 Testing Strategy

### Unit Tests

swift

`// MealTests.swift
import XCTest
@testable import CalSnap

final class MealTests: XCTestCase {
    
    func testPortionMultiplier() {
        let meal = Meal.mockBreakfast
        meal.portionMultiplier = 1.5
        
        XCTAssertEqual(meal.totalCalories, meal.calories * 1.5, accuracy: 0.01)
        XCTAssertEqual(meal.totalProtein, meal.protein * 1.5, accuracy: 0.01)
    }
    
    func testComponentScaling() {
        let component = MealComponent(
            name: "Rice",
            quantity: 100,
            unit: .grams,
            calories: 130,
            protein: 2.7,
            carbs: 28.2,
            fat: 0.3
        )
        
        component.customMultiplier = 1.5
        
        XCTAssertEqual(component.scaledCalories, 195, accuracy: 0.01)
    }
    
    func testAllergenDetection() {
        let meal = Meal.mockMealWithNuts
        XCTAssertTrue(meal.hasAllergenWarnings)
        XCTAssertTrue(meal.allergens.contains(.nuts))
    }
}`

### UI Tests

swift

`// HomeViewTests.swift
import XCTest

final class HomeViewUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testMealCardTap() throws {
        let mealCard = app.buttons["meal-card-0"]
        XCTAssertTrue(mealCard.exists)
        
        mealCard.tap()
        
        let mealDetailTitle = app.navigationBars.staticTexts.firstMatch
        XCTAssertTrue(mealDetailTitle.exists)
    }
    
    func testCameraButton() throws {
        let cameraButton = app.buttons["camera-button"]
        XCTAssertTrue(cameraButton.exists)
        
        cameraButton.tap()
        
        // Verify camera view appears
        let cameraView = app.otherElements["camera-view"]
        XCTAssertTrue(cameraView.waitForExistence(timeout: 2))
    }
}`

### 8.8 Performance Optimization

### Image Handling

swift

`// ImageService.swift
class ImageService {
    static let shared = ImageService()
    
    func compressImage(_ image: UIImage, maxSizeKB: Int = 500) -> Data? {
        var compression: CGFloat = 0.8
        var imageData = image.jpegData(compressionQuality: compression)
        
        while let data = imageData, data.count > maxSizeKB * 1024 && compression > 0.1 {
            compression -= 0.1
            imageData = image.jpegData(compressionQuality: compression)
        }
        
        return imageData
    }
    
    func generateThumbnail(_ image: UIImage, size: CGSize = CGSize(width: 128, height: 128)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: size))
        let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return thumbnail
    }
}`

### Lazy Loading

swift

`// HomeViewModel.swift
@Observable
class HomeViewModel {
    var meals: [Meal] = []
    var isLoadingMore = false
    private var currentPage = 0
    private let pageSize = 20
    
    func loadMeals() async {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        defer { isLoadingMore = false }
        
        do {
            let newMeals = try await persistenceService.fetchMeals(
                page: currentPage,
                pageSize: pageSize
            )
            meals.append(contentsOf: newMeals)
            currentPage += 1
        } catch {
            print("Error loading meals: \(error)")
        }
    }
}`

### 8.9 Accessibility Implementation

swift

`// AccessibilityHelpers.swift
extension View {
    func mealCardAccessibility(meal: Meal) -> some View {
        self
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(meal.name), \(Int(meal.totalCalories)) calories")
            .accessibilityHint("Double tap to view meal details")
            .accessibilityAddTraits(.isButton)
    }
    
    func macroAccessibility(label: String, current: Int, target: Int) -> some View {
        self
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(label): \(current) of \(target) grams")
            .accessibilityValue("\(Int(Double(current) / Double(target) * 100)) percent")
    }
}

// Usage in MealCard
MealCardView(meal: meal)
    .mealCardAccessibility(meal: meal)`

---

## 9. Documentation for Cursor AI

To enable Cursor AI to effectively build CalSnap, create these supporting markdown files in a `Documentation/` folder:

### 9.1 PROJECT_CONTEXT.md

markdown

`# CalSnap Project Context

## What is CalSnap?
CalSnap is an iOS meal tracking app that uses AI to analyze food photos and provide instant nutrition information.

## Current Phase
We are in the UI implementation phase. No backend, AI integration, or persistence has been built yet.

## Working with Mock Data
All screens and components should use `MockData` structs. Never make network calls or database queries.

## Key Constraints
- iOS 17+ target
- SwiftUI only (no UIKit except AVFoundation for camera)
- SwiftData for future persistence
- Gemini 2.0 Flash for future AI
- Design system must be followed strictly

## File Organization
- Features/[FeatureName]/ - Feature modules
- DesignSystem/ - Reusable components and theme
- Core/Models/ - Data models
- Core/Services/ - Service layer (not yet implemented)`

### 9.2 DESIGN_GUIDELINES.md

markdown

`# CalSnap Design Guidelines

## Visual Hierarchy
1. **Primary actions**: Green buttons, prominent placement
2. **Calories**: Largest number, orange color (#F97316)
3. **Macros**: Color-coded pills (Protein: Pink, Carbs: Green, Fat: Blue)
4. **Warnings**: Orange/red allergen badges

## Spacing Rules
- Card padding: 16pt
- Section spacing: 24pt
- Component gaps: 12pt
- Never use raw numbers - always use `AppTheme.Spacing.[size]`

## Typography
- Numbers: SF Pro Rounded, Semibold
- Body text: SF Pro Text, Regular
- Headlines: SF Pro Display, Bold
- Always support Dynamic Type

## Colors
- Use semantic names: `AppTheme.Colors.primary`, NOT `Color.green`
- All colors must have dark mode variants
- Reference the ColorPalette.swift file

## Interactions
- All buttons must have haptic feedback
- Sliders should have haptic feedback at key percentages (50%, 100%, 150%, 200%)
- Loading states are mandatory for async operations
- Empty states must have helpful CTAs`

### 9.3 COMPONENT_PATTERNS.md

markdown

`# Component Building Patterns

## Anatomy of a Good Component
```swift
import SwiftUI

struct MyComponent: View {
    // 1. Props (dependencies injected)
    let data: SomeData
    let onAction: () -> Void
    
    // 2. State (internal only)
    @State private var isExpanded = false
    
    // 3. Body
    var body: some View {
        // UI here
    }
}

// 4. Previews (MANDATORY)
#Preview("Default") {
    MyComponent(
        data: MockData.sample,
        onAction: {}
    )
}

#Preview("Edge Case") {
    MyComponent(
        data: MockData.edgeCase,
        onAction: {}
    )
}

#Preview("Dark Mode") {
    MyComponent(
        data: MockData.sample,
        onAction: {}
    )
    .preferredColorScheme(.dark)
}
```

## Common Patterns

### Card Container
Always wrap content in `BaseCard`:
```swift
BaseCard {
    VStack {
        // Content
    }
}
```

### Progress Indicators
Use `ProgressBar` component:
```swift
ProgressBar(
    progress: 0.65,
    color: AppTheme.Colors.primary,
    height: 8
)
```

### Buttons
Use design system buttons:
```swift
PrimaryButton(
    title: "Analyze",
    icon: "camera",
    action: { }
)
```

## Anti-Patterns (DON'T DO)
- ❌ Hard-coded colors: `Color.blue`
- ❌ Hard-coded fonts: `Font.system(size: 16)`
- ❌ Hard-coded spacing: `.padding(12)`
- ❌ No previews
- ❌ ViewModels in UI files
- ❌ Business logic in Views`

### 9.4 MOCK_DATA_GUIDE.md

markdown

`# Working with Mock Data

## Available Mock Data

### MockData.swift Structure
```swift
enum MockData {
    // Single instances
    static let sampleMeal: Meal
    static let sampleBreakfast: Meal
    static let sampleLunch: Meal
    static let sampleDinner: Meal
    
    // Collections
    static let sampleMeals: [Meal]
    static let sampleComponents: [MealComponent]
    
    // Edge cases
    static let mealWithLongName: Meal
    static let mealWithoutImage: Meal
    static let mealWithLowConfidence: Meal
    static let mealWithAllergens: Meal
    
    // Daily data
    static let sampleDailyGoals: DailyGoals
    static let sampleProgress: DailyProgress
}
```

## Creating New Mock Data

When you need new scenarios:
```swift
extension MockData {
    static let myNewScenario: Meal {
        Meal(
            id: UUID(),
            name: "Test Meal",
            calories: 500,
            protein: 30,
            carbs: 50,
            fat: 15,
            // ... rest of properties
        )
    }
}
```

## Using Mock Data in Views
```swift
struct MyView: View {
    let meal: Meal  // Injected dependency
    
    var body: some View {
        // Use meal
    }
}

#Preview {
    MyView(meal: MockData.sampleBreakfast)
}
```

## DO NOT
- ❌ Make network requests
- ❌ Access databases
- ❌ Call AI services
- ❌ Use UserDefaults
- ❌ Access file system

All data comes from MockData until Phase 11.`

### 9.5 CURSOR_WORKFLOW.md

markdown

`# Cursor AI Workflow for CalSnap

## How to Use This Document

This project is designed to be built incrementally with Cursor AI assistance. Follow these guidelines:

## 1. Before Starting a New File

1. Read the relevant section in the main specification
2. Check if related components already exist
3. Identify which mock data you'll need

## 2. Prompting Pattern

Use this template:`

Create a SwiftUI [component/screen] for CalSnap that:

- Follows the design system in DesignSystem/Theme/AppTheme.swift
- Uses mock data from Core/MockData/MockData.swift
- Includes 3+ preview variants (default, edge case, dark mode)
- Implements accessibility labels
- Has no business logic (UI only)

Specific requirements: [List specific requirements from spec]

`## 3. After Code Generation

1. **Compile immediately** - Fix any errors before proceeding
2. **Check previews** - All variants should render
3. **Test dark mode** - Toggle and verify
4. **Test Dynamic Type** - Increase text size
5. **Commit** - Small, working increments

## 4. File-by-File Approach

Build in this order:
1. Theme files (if not done)
2. Simple components (buttons, cards)
3. Complex components (sliders, lists)
4. Screens (home, detail, settings)
5. Navigation shell
6. Polish and accessibility

## 5. Common Issues & Fixes

### Issue: Component doesn't compile
**Fix**: Check import statements, ensure AppTheme is accessible

### Issue: Preview crashes
**Fix**: Verify mock data exists, check for force-unwraps

### Issue: Colors look wrong
**Fix**: Use AppTheme.Colors, not hard-coded values

### Issue: Text gets clipped
**Fix**: Use `.fixedSize(horizontal: false, vertical: true)` or `.lineLimit(nil)`

## 6. Quality Checklist

Before marking a component "done":
- [ ] Compiles without warnings
- [ ] All previews work
- [ ] Dark mode tested
- [ ] Large text tested
- [ ] Uses AppTheme exclusively
- [ ] No business logic in View
- [ ] Accessibility labels present
- [ ] No TODOs or placeholder comments

## 7. Getting Unstuck

If Cursor generates incorrect code:
1. Reference the specific section in the main spec
2. Show the existing design system files
3. Provide a working example of a similar component
4. Ask for "refactor to match this pattern"

## 8. Progressive Enhancement

Build in layers:
1. **Structure** - Layout and static content
2. **Styling** - Colors, spacing, typography
3. **Interaction** - Buttons, gestures
4. **States** - Loading, empty, error
5. **Accessibility** - VoiceOver, Dynamic Type
6. **Polish** - Animations, haptics`

### 9.6 TROUBLESHOOTING.md

markdown

`# Common Issues & Solutions

## Build Errors

### "Cannot find 'AppTheme' in scope"
**Cause**: Import missing or wrong target membership
**Fix**: Add `import CalSnap` or check file target

### "Type 'Meal' has no member 'mockBreakfast'"
**Cause**: MockData extension not loaded
**Fix**: Ensure MockData.swift is in target, rebuild

## Preview Issues

### Preview crashes on load
**Cause**: Mock data force-unwrap or missing
**Fix**: Check all mock data is properly initialized

### Preview shows blank screen
**Cause**: Background color matches content
**Fix**: Add explicit background or check dark mode

## Layout Issues

### Text gets clipped
**Solution**:
```swift
Text(longString)
    .fixedSize(horizontal: false, vertical: true)
    .lineLimit(nil)
```

### Content overflows card
**Solution**:
```swift
ScrollView {
    content
}
.frame(maxHeight: .infinity)
```

## Dark Mode Issues

### Colors don't adapt
**Cause**: Using hard-coded colors
**Fix**: Use AppTheme.Colors which have automatic variants

### Images too bright in dark mode
**Solution**:
```swift
Image("photo")
    .renderingMode(.original) // Don't tint
```

## Accessibility Issues

### VoiceOver reads wrong order
**Solution**:
```swift
.accessibilityElement(children: .combine)
.accessibilityLabel("Correct order text")
```

### Buttons not tappable
**Cause**: Hit area too small
**Fix**: Ensure minimum 44x44pt tap area

## Performance Issues

### List scrolling is laggy
**Solution**: Use LazyVStack instead of VStack
```swift
ScrollView {
    LazyVStack {
        ForEach(meals) { meal in
            MealCard(meal: meal)
        }
    }
}
```

### Images loading slowly
**Solution**: Use async image loading
```swift
AsyncImage(url: url) { image in
    image.resizable()
} placeholder: {
    ProgressView()
}
````

---

## 10. Next Steps After UI Completion

Once the UI is approved and all phases 1-10 are complete:

### Phase 11: Backend Integration

1. **Set up backend proxy**
    - Deploy Cloud Run/Lambda function
    - Secure API key storage
    - Implement rate limiting
2. **Integrate AI service**
    - Replace MockAIService with GeminiAIService
    - Implement error handling
    - Add retry logic
3. **Enable persistence**
    - Configure SwiftData + CloudKit
    - Implement data migration
    - Test sync across devices
4. **Implement subscriptions**
    - Configure StoreKit 2
    - Add paywall
    - Implement feature gating
5. **Testing & QA**
    - End-to-end testing
    - Performance profiling
    - User acceptance testing
6. **App Store preparation**
    - Screenshots
    - App Store description
    - Privacy policy
    - Terms of service

---

## 11. Success Criteria

### UI Phase Complete When:

- ✅ All screens render correctly on iPhone SE through Pro Max
- ✅ Dark mode works throughout
- ✅ Dynamic Type scales properly
- ✅ VoiceOver navigation is logical
- ✅ All interactions feel responsive (60fps)
- ✅ Empty states are helpful
- ✅ Error states are clear
- ✅ Loading states are smooth
- ✅ No placeholder text or TODOs
- ✅ Product owner approves the experience

### Production Ready When:

- ✅ All of above PLUS
- ✅ Backend integrated and tested
- ✅ AI analysis working reliably
- ✅ Data persists across app restarts
- ✅ iCloud sync working
- ✅ Subscription flow complete
- ✅ Analytics implemented
- ✅ Crash reporting active
- ✅ App Store approved
- ✅ Beta testing complete