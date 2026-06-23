//
//  OnboardingViewModel.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 21/06/2026.
//




import Foundation
import Combine

final class OnboardingViewModel: ObservableObject {

    @Published var data = OnboardingData()
    @Published private(set) var currentStep: OnboardingStep = .gender

    init(startingAt step: OnboardingStep = .gender) {
        self.currentStep = step
    }

    var canGoBack: Bool { currentStep != OnboardingStep.allCases.first }

    var canProceed: Bool {
        switch currentStep {
        case .gender:       return data.gender != nil
        case .birthday:     return data.dateOfBirth != nil
        case .measurements: return data.heightCm != nil && data.weightKg != nil
        case .goal:         return true   // TODO: gate on goal selection once built
        }
    }

    func goNext() {
        guard canProceed else { return }
        guard let next = OnboardingStep(rawValue: currentStep.rawValue + 1) else {
            finishOnboarding(); return
        }
        currentStep = next
    }

    func goBack() {
        guard let previous = OnboardingStep(rawValue: currentStep.rawValue - 1) else { return }
        currentStep = previous
    }

    private func finishOnboarding() {
        print("Onboarding complete:", data)
    }
}
