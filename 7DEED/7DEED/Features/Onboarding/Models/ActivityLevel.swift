//
//  ActivityLevel.swift
//  7DEED
//

enum ActivityLevel: String, CaseIterable, Identifiable, Selectable {
    case sedentary
    case light
    case moderate
    case active
    case veryActive

    var id: String { rawValue }

    // rawValues match the SRS data model and stay stable for backend mapping.
    // Display labels were realigned per design: `active` shows "Very Active"
    // and `veryActive` shows "Extremely Active". Mind that gap when reading code.
    var displayName: String {
        switch self {
        case .sedentary:  return "Sedentary"
        case .light:      return "Lightly Active"
        case .moderate:   return "Moderately Active"
        case .active:     return "Very Active"
        case .veryActive: return "Extremely Active"
        }
    }

    var description: String {
        switch self {
        case .sedentary:  return "Office job, little to no exercise"
        case .light:      return "Light exercise or sports 1–3 days a week"
        case .moderate:   return "Moderate exercise or sports 3–5 days a week"
        case .active:     return "Hard exercise or sports 6–7 days a week"
        case .veryActive: return "Very heavy physical training/labor, training twice a day"
        }
    }

    /// TDEE multiplier (Mifflin–St Jeor). Kept for the later logic phase.
    /// Intentionally NOT shown in the UI.
    var multiplier: Double {
        switch self {
        case .sedentary:  return 1.2
        case .light:      return 1.375
        case .moderate:   return 1.55
        case .active:     return 1.725
        case .veryActive: return 1.9
        }
    }
}
