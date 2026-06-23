//
//  ActivityLevel.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 22/06/2026.
//


//  ActivityLevel.swift — 7DEED

enum ActivityLevel: String, CaseIterable, Identifiable, Selectable {
    case sedentary
    case light
    case moderate
    case active
    case veryActive

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .sedentary:  return "Sedentary"
        case .light:      return "Lightly Active"
        case .moderate:   return "Moderately Active"
        case .active:     return "Active"
        case .veryActive: return "Very Active"
        }
    }

    /// TDEE = BMR × multiplier (Mifflin-St Jeor). You'll use this after the Goal step.
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
