# 7DEED Project Structure Report

## Overview

`7DEED` is a SwiftUI iOS project organized around a feature-based onboarding flow, shared reusable components, and a small design system.

The current app structure is clear and scalable for an early-stage SwiftUI project:

```text
7DEED/
├── 7DEED/
│   ├── -DEED-Info.plist
│   ├── _DEEDApp.swift
│   ├── ContentView.swift
│   ├── Core/
│   ├── Features/
│   ├── Resources/
│   └── Shared/
├── 7DEEDTests/
├── 7DEEDUITests/
└── Products/
```

## Full File Structure

```text
7DEED/
├── 7DEED/
│   ├── -DEED-Info.plist
│   ├── Core/
│   │   └── Extensions/
│   │       └── Color+Extensions.swift
│   ├── Features/
│   │   └── Onboarding/
│   │       ├── Models/
│   │       │   └── Gender.swift
│   │       ├── ViewModels/
│   │       │   └── OnboardingViewModel.swift
│   │       └── Views/
│   │           ├── GenderSelectionView.swift
│   │           └── OnboardingWelcomeView.swift
│   ├── Resources/
│   │   ├── Assets.xcassets
│   │   └── Fonts/
│   │       ├── 43-DecoType-Naskh-Variants.ttf
│   │       └── PlusJakartaSans-VariableFont_wght.ttf
│   ├── Shared/
│   │   ├── Components/
│   │   │   ├── PrimaryButton.swift
│   │   │   ├── ProgressIndicator.swift
│   │   │   └── SelectionButton.swift
│   │   └── DesignSystem/
│   │       ├── AppColors.swift
│   │       ├── AppGradients.swift
│   │       ├── AppRadius.swift
│   │       └── AppSpacing.swift
│   ├── _DEEDApp.swift
│   └── ContentView.swift
├── 7DEEDTests/
│   └── _DEEDTests.swift
├── 7DEEDUITests/
│   ├── _DEEDUITests.swift
│   └── _DEEDUITestsLaunchTests.swift
└── Products/
    ├── 7DEED.app
    ├── 7DEEDTests.xctest
    └── 7DEEDUITests.xctest
```

## App Entry

### `_DEEDApp.swift`

This is the main app entry point.

It launches:

```swift
ContentView()
```

It also prints all available font families at startup, likely to verify custom font registration and exact font names.

### `ContentView.swift`

This file still contains the default SwiftUI starter view:

```swift
Text("Hello, world!")
```

The onboarding views exist, but they are not currently connected to the app launch flow through `ContentView`.

## Core

```text
Core/
└── Extensions/
    └── Color+Extensions.swift
```

### `Color+Extensions.swift`

Adds a convenience initializer:

```swift
Color(hex: String)
```

This allows SwiftUI colors to be created from hex values such as:

```swift
Color(hex: "#7C3AED")
```

It currently supports 6-character RGB hex values.

## Features

```text
Features/
└── Onboarding/
    ├── Models/
    ├── ViewModels/
    └── Views/
```

The project currently has one feature area: onboarding.

## Onboarding Feature

### Models

```text
Models/
└── Gender.swift
```

`Gender.swift` defines the available gender choices:

```swift
enum Gender: String, CaseIterable {
    case male = "Male"
    case female = "Female"
}
```

### View Models

```text
ViewModels/
└── OnboardingViewModel.swift
```

`OnboardingViewModel.swift` stores onboarding state:

```swift
@Published var selectedGender: Gender?
```

The view model currently tracks only the selected gender.

### Views

```text
Views/
├── GenderSelectionView.swift
└── OnboardingWelcomeView.swift
```

### `OnboardingWelcomeView.swift`

This screen contains:

- Dark app background
- Header text: `Welcome to`
- Logo image: `hadeed_logo`
- Subtitle: `Your all-in-one fitness tracker`
- Athlete image: `onboarding_athlete`
- Primary button: `Start Your Journey`

The button action is currently empty.

### `GenderSelectionView.swift`

This screen contains:

- Background using `AppColors.background`
- `ProgressIndicator(currentStep: 1, totalSteps: 4)`
- Title: `Tell us about you`
- Subtitle: `help us personalize your plan`
- Athlete image: `woman1`
- Gender section title: `Your gender`
- Selection buttons for `Male` and `Female`
- Primary button: `Next`

The selected gender is stored in:

```swift
@StateObject private var viewModel = OnboardingViewModel()
```

The `Next` button action is currently empty.

## Shared Components

```text
Shared/
└── Components/
    ├── PrimaryButton.swift
    ├── ProgressIndicator.swift
    └── SelectionButton.swift
```

### `PrimaryButton.swift`

A reusable full-width call-to-action button.

Current behavior:

- Accepts a title
- Accepts an action closure
- Uses white text
- Uses a purple vertical gradient
- Uses fixed height of `56`
- Uses rounded corners

### `ProgressIndicator.swift`

A reusable step progress indicator.

Current behavior:

- Accepts `currentStep`
- Accepts `totalSteps`
- Renders horizontal rounded bars
- Uses `AppColors.primary` for completed steps
- Uses translucent white for incomplete steps

### `SelectionButton.swift`

A reusable selectable row button.

Current behavior:

- Accepts a title
- Accepts selected state
- Accepts an action closure
- Shows a circular selection indicator
- Uses a purple border
- Adds a purple-tinted background when selected

## Design System

```text
Shared/
└── DesignSystem/
    ├── AppColors.swift
    ├── AppGradients.swift
    ├── AppRadius.swift
    └── AppSpacing.swift
```

### `AppColors.swift`

Centralizes app color references from the asset catalog:

```swift
background
surface
primary
secondary
accent
success
error
textPrimary
textSecondary
```

These colors depend on matching named colors in `Assets.xcassets`.

### `AppGradients.swift`

This file currently exists but does not define gradients yet.

This would be a good place to move shared gradients, such as the purple gradient currently defined inside `PrimaryButton`.

### `AppRadius.swift`

Defines reusable corner radius values:

```swift
small = 12
medium = 20
large = 30
pill = 50
```

### `AppSpacing.swift`

Defines reusable spacing values:

```swift
xs = 4
sm = 8
md = 16
lg = 24
xl = 32
xxl = 48
```

## Resources

```text
Resources/
├── Assets.xcassets
└── Fonts/
    ├── 43-DecoType-Naskh-Variants.ttf
    └── PlusJakartaSans-VariableFont_wght.ttf
```

### Assets

The app currently references these image assets:

```text
hadeed_logo
onboarding_athlete
woman1
```

The app also references these named color assets:

```text
AppBackground
AppSurface
PrimaryPurple
SecondaryPurple
AccentPurple
SuccessGreen
ErrorRed
TextPrimary
TextSecondary
```

### Fonts

The project includes:

```text
43-DecoType-Naskh-Variants.ttf
PlusJakartaSans-VariableFont_wght.ttf
```

The info plist currently registers only:

```text
PlusJakartaSans-VariableFont_wght.ttf
```

If `43-DecoType-Naskh-Variants.ttf` should be used in the app, it should also be added to the `UIAppFonts` array in `-DEED-Info.plist`.

## Tests

```text
7DEEDTests/
└── _DEEDTests.swift

7DEEDUITests/
├── _DEEDUITests.swift
└── _DEEDUITestsLaunchTests.swift
```

### Unit Tests

The unit test target uses Swift Testing:

```swift
import Testing
```

The current test file contains only the default placeholder test.

### UI Tests

The UI test target uses XCTest and XCUIAutomation:

```swift
import XCTest
```

The current UI tests are mostly default template tests:

- Launch app
- Measure launch performance
- Capture launch screenshot

## Current Architecture Summary

The project is currently organized like this:

```text
App startup         -> _DEEDApp.swift and ContentView.swift
Feature screens     -> Features/Onboarding/Views
Feature state       -> Features/Onboarding/ViewModels
Feature models      -> Features/Onboarding/Models
Reusable UI         -> Shared/Components
Design tokens       -> Shared/DesignSystem
General extensions  -> Core/Extensions
Assets and fonts    -> Resources
Tests               -> 7DEEDTests and 7DEEDUITests
```

## Current Gaps

1. `ContentView` still shows the default SwiftUI starter screen.
2. `OnboardingWelcomeView` is not connected to app launch.
3. `GenderSelectionView` is not connected to the welcome screen.
4. `Start Your Journey` button has no action.
5. `Next` button has no action.
6. `AppGradients.swift` is empty.
7. `43-DecoType-Naskh-Variants.ttf` is present but not registered in the plist.
8. Unit and UI tests are still placeholders.
9. `OnboardingViewModel` imports Combine, while the project can likely stay closer to modern SwiftUI observation patterns later.

## Recommended Next Steps

1. Replace the default `ContentView` body with `OnboardingWelcomeView`.
2. Add navigation from `OnboardingWelcomeView` to `GenderSelectionView`.
3. Move reusable gradients into `AppGradients.swift`.
4. Use `AppSpacing` and `AppRadius` consistently inside shared components.
5. Register the second font if it is needed.
6. Add focused tests for onboarding state and UI flow.

