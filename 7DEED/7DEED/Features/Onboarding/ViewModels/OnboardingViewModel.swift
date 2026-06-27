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

    /// The active ordered flow. Maintain (or no goal yet) ends at .goal;
    /// Lose Fat / Gain Muscle append the .target step.
    var path: [OnboardingStep] {
        switch data.goal {
        case .loseFat, .gainMuscle:
            return [.gender, .birthday, .measurements, .goal, .target]
        case .maintainWeight, .none:
            return [.gender, .birthday, .measurements, .goal]
        }
    }

    var totalSteps: Int { path.count }
    var canGoBack: Bool { currentStep != path.first }

    var canProceed: Bool {
        switch currentStep {
        case .gender:       return data.gender != nil
        case .birthday:     return data.dateOfBirth != nil
        case .measurements: return data.heightCm != nil && data.weightKg != nil
        case .goal:         return data.goal != nil
        case .target:       return data.targetWeightKg != nil && data.weeklyRate != nil
        }
    }

    func goNext() {
        guard canProceed, let idx = path.firstIndex(of: currentStep) else { return }
        let next = idx + 1
        guard next < path.count else { finishOnboarding(); return }
        currentStep = path[next]
    }

    func goBack() {
        guard let idx = path.firstIndex(of: currentStep), idx > 0 else { return }
        currentStep = path[idx - 1]
    }

    private func finishOnboarding() {
        print("Onboarding complete:", data)
    }
}
