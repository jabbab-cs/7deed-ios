//
//  NutritionModels.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 27/06/2026.
//

//
//  NutritionModels.swift — 7DEED
//  Immutable value types for the nutrition-plan feature.
//  All math lives in NutritionCalculator; these types only carry data.
//

import Foundation

// MARK: - Goal direction

/// Derived by comparing target vs current weight (per spec).
/// `Gender` already serves as the "Sex" enum the spec asks for.
enum GoalDirection: Equatable {
    case cutting        // target < current
    case maintenance    // target == current, or no target (Maintain path)
    case bulking        // target > current

    static func resolve(currentWeightKg: Double, targetWeightKg: Double?) -> GoalDirection {
        guard let target = targetWeightKg else { return .maintenance }
        if target < currentWeightKg { return .cutting }
        if target > currentWeightKg { return .bulking }
        return .maintenance
    }

    /// Marketing label shown on the plan screen.
    var summaryLabel: String {
        switch self {
        case .cutting:     return "Lose Weight"
        case .maintenance: return "Maintain"
        case .bulking:     return "Gain Muscle"
        }
    }
}

// MARK: - Macros

/// Whole-gram macro amounts. Grams are integers because that's how users
/// log food and edit values; the 4 kcal validation tolerance exists to
/// absorb the rounding that integer grams introduce.
struct Macros: Equatable {
    let proteinGrams: Int
    let carbGrams: Int
    let fatGrams: Int

    /// 4 kcal/g protein, 4 kcal/g carbs, 9 kcal/g fat.
    var calories: Int { proteinGrams * 4 + carbGrams * 4 + fatGrams * 9 }

    var proteinCalories: Int { proteinGrams * 4 }
    var carbCalories: Int    { carbGrams * 4 }
    var fatCalories: Int     { fatGrams * 9 }
}

// MARK: - Validation

enum MacroValidationState: Equatable {
    case valid                          // within tolerance of target
    case underTarget(remaining: Int)    // need this many more kcal
    case overTarget(excess: Int)        // this many kcal over
    case invalidInput                   // negative / unparseable
}

// MARK: - Inputs

/// Everything the calculator needs. Built from OnboardingData via `from(_:)`.
struct PlanInput: Equatable {
    let sex: Gender
    let currentWeightKg: Double
    let targetWeightKg: Double?     // nil = Maintain path
    let heightCm: Double
    let age: Int
    let activityLevel: ActivityLevel
    let weeklyRateKg: Double        // 0 for maintenance

    /// Bridge from onboarding. Returns nil if a required field is missing.
    /// Age is computed HERE (logic phase) — Calendar accounts for month/day.
    static func from(_ data: OnboardingData) -> PlanInput? {
        guard let sex = data.gender,
              let dob = data.dateOfBirth,
              let height = data.heightCm,
              let weight = data.weightKg else { return nil }

        let age = Calendar.current
            .dateComponents([.year], from: dob, to: Date()).year ?? 0

        return PlanInput(
            sex: sex,
            currentWeightKg: weight,
            targetWeightKg: data.targetWeightKg,   // nil on Maintain
            heightCm: height,
            age: age,
            activityLevel: data.activityLevel,
            weeklyRateKg: data.weeklyRate ?? 0
        )
    }
}

// MARK: - Output

struct NutritionPlan: Equatable {
    let bmr: Double
    let tdee: Double
    let targetCalories: Int
    let direction: GoalDirection
    let weeklyRateKg: Double
    let currentWeightKg: Double
    let targetWeightKg: Double?
    let defaultMacros: Macros
    let estimatedWeeks: Int?   // screenshot-derived (see note), NOT in the spec
}
