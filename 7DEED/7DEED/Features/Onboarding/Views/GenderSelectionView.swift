//  GenderSelectionView.swift — 7DEED

import SwiftUI

struct GenderSelectionView: View {

    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        OnboardingScaffold(
            progressStep: viewModel.currentStep.stepNumber,   // ← from the VM, not hardcoded
            totalSteps: OnboardingStep.totalSteps,
            showsBackButton: viewModel.canGoBack,
            isNextEnabled: viewModel.canProceed,
            imageName: "woman1",
            imageScale: 1.0,                          // tune in canvas
            imageOffset: CGSize(width: 34, height: 34), // ← put your old nudge here
            onBack: viewModel.goBack,
            onNext: viewModel.goNext
        ) {
            genderSection
        }
    }

    private var genderSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Your gender")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(Gender.allCases) { gender in
                SelectionButton(
                    title: gender.displayName,
                    isSelected: viewModel.data.gender == gender
                ) {
                    viewModel.data.gender = gender
                }
            }
        }
        .padding(.top, AppSpacing.md)
    }
}

#Preview {
    GenderSelectionView(viewModel: OnboardingViewModel(startingAt: .gender))
}
