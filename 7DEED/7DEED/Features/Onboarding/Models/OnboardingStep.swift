//
//  OnboardingStep.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 21/06/2026.
//


enum OnboardingStep: Int, CaseIterable {
    case gender
    case birthday
    case measurements
    case goal
    case target          // conditional: only Lose Fat / Gain Muscle

    var stepNumber: Int { rawValue + 1 }
    static var totalSteps: Int { allCases.count }   // kept for compatibility; prefer viewModel.totalSteps
}
