# CalSnap

CalSnap is an iOS meal tracking app that uses AI to analyze food photos and provide instant nutrition information. Built with **SwiftUI** for iOS 17+.

## Current Status

**Phase:** UI-first development  
**Backend/AI:** Not implemented yet  
**Persistence:** Not implemented yet

## Tech Stack

- **UI Framework:** SwiftUI (iOS 17+)
- **Architecture:** MVVM
- **Future Persistence:** SwiftData
- **Future AI:** Gemini 2.0 Flash

## Project Structure

```
CalSnap/
├── App/                    # App entry point
├── Features/
│   ├── Home/              # Main dashboard
│   ├── MealDetail/        # Meal editing screen
│   ├── Settings/          # User preferences
│   └── Goals/             # Daily goals setup
├── DesignSystem/
│   ├── Theme/             # Colors, Typography, Spacing
│   └── Components/        # Reusable UI components
├── Models/                # Data models
├── MockData/              # Sample data for previews
└── Documentation/         # Project specs and guides
```

## Documentation

All project documentation lives in `CalSnap/Documentation/`:

| Document | Purpose |
|----------|---------|
| `PRODUCT_SPEC.md` | **Source of truth** - UI, UX, data models, behavior |
| `IMPLEMENTATION_PLAN.md` | Build order and development phases |
| `PROJECT_CONTEXT.md` | Project overview and constraints |
| `DESIGN_GUIDELINES.md` | Visual hierarchy, spacing, colors |
| `COMPONENT_PATTERNS.md` | Component structure with code examples |
| `MOCK_DATA_GUIDE.md` | Working with mock data |
| `CURSOR_WORKFLOW.md` | AI-assisted development workflow |
| `TROUBLESHOOTING.md` | Common issues and solutions |

## Working with Cursor AI

This project is designed for AI-assisted development. See `.cursorrules` for guidelines that help Cursor generate consistent, high-quality code.

**Key rules:**
- Every component must have SwiftUI previews
- All data comes from MockData (no networking)
- Use AppTheme for colors, typography, and spacing
- Follow the 3-layer semantic color system

## Getting Started

1. Open `CalSnap.xcodeproj` in Xcode 15+
2. Select an iOS 17+ simulator
3. Build and run (⌘R)
4. Use SwiftUI Previews for rapid iteration

## Design System

Colors, typography, and spacing are centralized in `DesignSystem/Theme/`:

- **Colors:** 3-layer system (Brand → Domain → UI Role) with automatic Dark Mode
- **Typography:** Dynamic Type based for accessibility
- **Spacing:** 4pt grid system (xxs, xs, sm, md, lg, xl)
- **Shadows:** Minimal, purposeful elevation

