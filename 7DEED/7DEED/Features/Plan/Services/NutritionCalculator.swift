//
//  NutritionCalculator.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 27/06/2026.
//


//
//  NutritionCalculator.swift — 7DEED
//  Pure, side-effect-free nutrition math. No SwiftUI, no state.
//  Mifflin–St Jeor BMR → TDEE → calorie target → default macros → validation.
//  Double internally; rounds to whole kcal / grams at the output boundary.
//

import Foundation

enum NutritionCalculator {

    /// Floor for the daily calorie target. Named so it's easy to tune later
    /// (could be made sex-specific: ~1200 female / ~1500 male).
    static let minimumDailyCalories: Double = 1200

    /// Approx energy in 1 kg of body mass. delta/day = rate × this ÷ 7,
    /// which reproduces the spec table exactly:
    /// 0.25→275  0.50→550  0.75→825  |  0.20→220  0.40→440
    private static let kcalPerKg: Double = 7700

    // MARK: BMR

    static func bmr(sex: Gender, weightKg: Double, heightCm: Double, age: Int) -> Double {
        let base = (10 * weightKg) + (6.25 * heightCm) - (5 * Double(age))
        return sex == .male ? base + 5 : base - 161
    }

    // MARK: TDEE

    static func tdee(bmr: Double, activityLevel: ActivityLevel) -> Double {
        bmr * activityLevel.multiplier
    }

    // MARK: Calorie target

    static func dailyCalorieDelta(weeklyRateKg: Double) -> Double {
        weeklyRateKg * kcalPerKg / 7
    }

    static func targetCalories(tdee: Double,
                               direction: GoalDirection,
                               weeklyRateKg: Double) -> Int {
        let delta = dailyCalorieDelta(weeklyRateKg: weeklyRateKg)
        let raw: Double
        switch direction {
        case .cutting:     raw = tdee - delta
        case .bulking:     raw = tdee + delta
        case .maintenance: raw = tdee
        }
        return Int(max(minimumDailyCalories, raw).rounded())
    }

    // MARK: Default macros (uses CURRENT body weight for protein, per spec)

    static func defaultMacros(targetCalories: Int, currentWeightKg: Double) -> Macros {
        let target = Double(targetCalories)

        let protein = Int((2.2 * currentWeightKg).rounded())          // 2.2 g/kg
        let fat = Int((target * 0.25 / 9).rounded())                  // 25% of kcal

        // Carbs are the balancing macro: fill whatever kcal remain after
        // the (rounded) protein and fat, so the total lands closest to target.
        let carbCalories = target - (Double(protein) * 4 + Double(fat) * 9)
        let carbs = max(0, Int((carbCalories / 4).rounded()))

        return Macros(proteinGrams: protein, carbGrams: carbs, fatGrams: fat)
    }

    // MARK: Validation

    static func validate(macros: Macros,
                         targetCalories: Int,
                         tolerance: Int = 4) -> MacroValidationState {
        if macros.proteinGrams < 0 || macros.carbGrams < 0 || macros.fatGrams < 0 {
            return .invalidInput
        }
        let diff = macros.calories - targetCalories
        if abs(diff) <= tolerance { return .valid }
        return diff < 0 ? .underTarget(remaining: -diff) : .overTarget(excess: diff)
    }

    // MARK: Whole-plan assembly

    static func makePlan(_ input: PlanInput) -> NutritionPlan {
        let bmrValue = bmr(sex: input.sex,
                           weightKg: input.currentWeightKg,
                           heightCm: input.heightCm,
                           age: input.age)
        let tdeeValue = tdee(bmr: bmrValue, activityLevel: input.activityLevel)
        let direction = GoalDirection.resolve(currentWeightKg: input.currentWeightKg,
                                              targetWeightKg: input.targetWeightKg)
        let target = targetCalories(tdee: tdeeValue,
                                    direction: direction,
                                    weeklyRateKg: input.weeklyRateKg)
        let macros = defaultMacros(targetCalories: target,
                                   currentWeightKg: input.currentWeightKg)

        return NutritionPlan(
            bmr: bmrValue,
            tdee: tdeeValue,
            targetCalories: target,
            direction: direction,
            weeklyRateKg: input.weeklyRateKg,
            currentWeightKg: input.currentWeightKg,
            targetWeightKg: input.targetWeightKg,
            defaultMacros: macros,
            estimatedWeeks: estimatedWeeks(current: input.currentWeightKg,
                                           target: input.targetWeightKg,
                                           weeklyRateKg: input.weeklyRateKg)
        )
    }

    /// Weeks to reach target at the chosen rate. NOT part of the pasted spec —
    /// added because the screenshot shows "Timeline · 20 weeks".
    static func estimatedWeeks(current: Double, target: Double?, weeklyRateKg: Double) -> Int? {
        guard let target, weeklyRateKg > 0 else { return nil }
        let diff = abs(target - current)
        guard diff > 0 else { return nil }
        return Int((diff / weeklyRateKg).rounded(.up))
    }
}
