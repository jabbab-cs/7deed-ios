//
//  GoalView.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 23/06/2026.
//


import SwiftUI

struct GoalView: View {

    @ObservedObject var viewModel: OnboardingViewModel

    private var buttonTitle: String {
        viewModel.data.goal == .maintainWeight ? "Build My Plan" : "Next"
    }

    var body: some View {
        OnboardingScaffold(
            progressStep: viewModel.currentStep.stepNumber,
            totalSteps: viewModel.totalSteps,                 // ← dynamic
            showsBackButton: viewModel.canGoBack,
            isNextEnabled: viewModel.canProceed,
            title: "What's your goal?",
            subtitle: "We'll tailor your plan to match it",
            nextButtonTitle: buttonTitle,                     // ← Maintain finishes; others go to Target
            imageName: "woman2",                         // ⚠️ replace with your real asset name
            imageScale: 1.4,                   // tune in canvas
            imageOffset: CGSize(width: -10, height: 40),
            imagePosition: .bottom,
            onBack: viewModel.goBack,
            onNext: viewModel.goNext
        ) {
            VStack(spacing: AppSpacing.md) {
                ForEach(FitnessGoal.allCases) { goal in
                    SelectionButton(
                        title: goal.displayName,
                        isSelected: viewModel.data.goal == goal,
                        indicatorPosition: .trailing
                    ) {
                        viewModel.data.goal = goal
                    }
                }
            }
            .padding(.top, AppSpacing.md)
        }
    }
}

#Preview {
    GoalView(viewModel: OnboardingViewModel(startingAt: .goal))
}
