//
//  PlanViewModel.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 27/06/2026.
//

//
//  PlanViewModel.swift — 7DEED
//  Holds the computed plan and manages user macro edits with live validation.
//  ObservableObject (NOT @Observable) for iOS 16. The math lives entirely in
//  NutritionCalculator — this class only orchestrates state.
//

import Foundation
import Combine

final class PlanViewModel: ObservableObject {

    let plan: NutritionPlan

    @Published private(set) var macros: Macros
    @Published private(set) var validation: MacroValidationState
    @Published var isEditing = false

    init(plan: NutritionPlan) {
        self.plan = plan
        self.macros = plan.defaultMacros
        self.validation = NutritionCalculator.validate(macros: plan.defaultMacros,
                                                       targetCalories: plan.targetCalories)
    }

    /// Positive = calories still available; negative = over target.
    var remainingCalories: Int { plan.targetCalories - macros.calories }

    var isValidForTracking: Bool { validation == .valid }

    // MARK: Edits — each clamps at 0 and revalidates immediately.
    // Protein is never silently overwritten; carbs can never go negative.

    func setProtein(_ grams: Int) {
        macros = Macros(proteinGrams: max(0, grams),
                        carbGrams: macros.carbGrams,
                        fatGrams: macros.fatGrams)
        revalidate()
    }

    func setCarbs(_ grams: Int) {
        macros = Macros(proteinGrams: macros.proteinGrams,
                        carbGrams: max(0, grams),
                        fatGrams: macros.fatGrams)
        revalidate()
    }

    func setFat(_ grams: Int) {
        macros = Macros(proteinGrams: macros.proteinGrams,
                        carbGrams: macros.carbGrams,
                        fatGrams: max(0, grams))
        revalidate()
    }

    /// Snap back to a valid plan: keep protein, fill the rest with carbs,
    /// and only if carbs would go negative, trim fat. Carbs never go below 0.
    func autoBalance() {
        let proteinKcal = macros.proteinCalories
        let fatKcal = macros.fatCalories
        let kcalForCarbs = plan.targetCalories - proteinKcal - fatKcal

        if kcalForCarbs >= 0 {
            let carbs = Int((Double(kcalForCarbs) / 4).rounded())
            macros = Macros(proteinGrams: macros.proteinGrams,
                            carbGrams: max(0, carbs),
                            fatGrams: macros.fatGrams)
        } else {
            // Carbs can't absorb it — reduce fat instead, carbs to 0.
            let kcalForFat = max(0, plan.targetCalories - proteinKcal)
            let fat = Int((Double(kcalForFat) / 9).rounded())
            macros = Macros(proteinGrams: macros.proteinGrams,
                            carbGrams: 0,
                            fatGrams: max(0, fat))
        }
        revalidate()
    }

    func resetToDefault() {
        macros = plan.defaultMacros
        revalidate()
    }

    /// Macro's share of the daily target, for the "31% / 44% / 25%" labels.
    func percent(ofCalories kcal: Int) -> Int {
        guard plan.targetCalories > 0 else { return 0 }
        return Int((Double(kcal) / Double(plan.targetCalories) * 100).rounded())
    }

    private func revalidate() {
        validation = NutritionCalculator.validate(macros: macros,
                                                  targetCalories: plan.targetCalories)
    }
}
