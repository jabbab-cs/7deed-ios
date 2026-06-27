//
//  OnboardingContainerView.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 23/06/2026.
//


//  OnboardingContainerView.swift — 7DEED
//  Owns the single source of truth. Welcome → switch-based step router.

import SwiftUI

struct OnboardingContainerView: View {

    @StateObject private var viewModel = OnboardingViewModel()
    @State private var hasStarted = false

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            if hasStarted {
                stepContent
                    .id(viewModel.currentStep)        // distinct identity → clean cross-fade
                    .transition(.opacity)
            } else {
                OnboardingWelcomeView(onStart: { hasStarted = true })
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: hasStarted)
        .animation(.easeInOut(duration: 0.25), value: viewModel.currentStep)
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
