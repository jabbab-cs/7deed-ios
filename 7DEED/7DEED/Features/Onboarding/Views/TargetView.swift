//
//  TargetView.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 23/06/2026.
//


//  TargetView.swift — 7DEED
//  Step 5 for Lose Fat / Gain Muscle. No hero image; scrollable middle, pinned header + button.

import SwiftUI

struct TargetView: View {

    @ObservedObject var viewModel: OnboardingViewModel

    private var goal: FitnessGoal { viewModel.data.goal ?? .loseFat }
    private var options: [WeightRateOption] { WeightRateCatalog.options(for: goal) }

    var body: some View {
        VStack(spacing: 0) {
            OnboardingHeader(
                progressStep: viewModel.currentStep.stepNumber,
                totalSteps: viewModel.totalSteps,
                title: "Set your target",
                subtitle: "How much do you want to weigh?",
                showsBackButton: viewModel.canGoBack,
                onBack: viewModel.goBack
            )

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    Text("Target Weight")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.top, AppSpacing.lg)

                    WeightScaleSlider(value: targetWeightBinding, range: weightRange)

                    Rectangle().fill(Color.white.opacity(0.1)).frame(height: 1)

                    Text(WeightRateCatalog.sectionTitle(for: goal))
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)

                    VStack(spacing: AppSpacing.md) {
                        ForEach(options) { option in
                            RateOptionCard(
                                rateText: String(format: "%g", option.rate),
                                unit: "kg/wk",
                                title: option.title,
                                subtitle: option.subtitle,
                                isSelected: viewModel.data.weeklyRate == option.rate,
                                isRecommended: option.isRecommended
                            ) {
                                viewModel.data.weeklyRate = option.rate
                            }
                        }
                    }
                    .padding(.top, AppSpacing.xs)
                    .padding(.bottom, AppSpacing.md)
                }
            }

            PrimaryButton(title: "Build My Plan",
                          isEnabled: viewModel.canProceed,
                          action: viewModel.goNext)
                .padding(.top, AppSpacing.sm)
                .padding(.bottom, AppSpacing.sm)
        }
        .padding(.horizontal, AppSpacing.lg)
        .background(AppColors.background.ignoresSafeArea())
        .onAppear(perform: seedDefaults)
    }

    // Layout range only (not business logic): a ±15kg window around current weight,
    // rounded to clean multiples of 5 so tick labels read nicely.
    private var weightRange: ClosedRange<Double> {
        let current = viewModel.data.weightKg ?? 70
        let lower = max(30, ((current - 15) / 5).rounded(.down) * 5)
        let upper = ((current + 15) / 5).rounded(.up) * 5
        return lower...upper
    }

    private var targetWeightBinding: Binding<Double> {
        Binding(
            get: { viewModel.data.targetWeightKg ?? viewModel.data.weightKg ?? weightRange.lowerBound },
            set: { viewModel.data.targetWeightKg = $0 }
        )
    }

    private func seedDefaults() {
        if viewModel.data.targetWeightKg == nil {
            let current = viewModel.data.weightKg ?? weightRange.lowerBound
            viewModel.data.targetWeightKg = min(weightRange.upperBound, max(weightRange.lowerBound, current))
        }
        if viewModel.data.weeklyRate == nil {
            viewModel.data.weeklyRate = options.first(where: \.isRecommended)?.rate ?? options.first?.rate
        }
    }
}

#Preview {
    let vm = OnboardingViewModel(startingAt: .target)
    vm.data.goal = .loseFat
    vm.data.weightKg = 70
    return TargetView(viewModel: vm)
}
