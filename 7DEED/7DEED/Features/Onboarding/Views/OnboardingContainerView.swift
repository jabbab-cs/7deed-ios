//
//  OnboardingContainerView.swift — 7DEED
//  Owns the single source of truth. Welcome → step router → plan screen.
//

import SwiftUI

struct OnboardingContainerView: View {

    @StateObject private var viewModel = OnboardingViewModel()
    @State private var hasStarted = false
    var onTrack: () -> Void = {}

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            if viewModel.isComplete, let input = PlanInput.from(viewModel.data) {
                PlanView(
                    plan: NutritionCalculator.makePlan(input),
                    onBack: viewModel.returnToOnboarding,
                    onTrack: onTrack
                )
                .transition(.opacity)
            } else if hasStarted {
                stepContent
                    .id(viewModel.currentStep)
                    .transition(.opacity)
            } else {
                OnboardingWelcomeView(onStart: { hasStarted = true })
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: hasStarted)
        .animation(.easeInOut(duration: 0.25), value: viewModel.currentStep)
        .animation(.easeInOut(duration: 0.25), value: viewModel.isComplete)
    }

    @ViewBuilder
    private var stepContent: some View {
        switch viewModel.currentStep {
        case .gender:       GenderSelectionView(viewModel: viewModel)
        case .birthday:     BirthdaySelectionView(viewModel: viewModel)
        case .measurements: MeasurementsView(viewModel: viewModel)
        case .goal:         GoalView(viewModel: viewModel)
        case .target:       TargetView(viewModel: viewModel)
        }
    }
}

#Preview { OnboardingContainerView() }
