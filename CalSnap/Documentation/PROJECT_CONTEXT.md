# CalSnap Project Context

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
- Core/Services/ - Service layer (not yet implemented)

