//
//  GenderSelectionView.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 21/06/2026.
//


import SwiftUI

struct GenderSelectionView: View {

    @StateObject private var viewModel = OnboardingViewModel()

    var body: some View {

        ZStack {

            AppColors.background
                .ignoresSafeArea()

            VStack(spacing: 0) {

                ProgressIndicator(
                    currentStep: 1,
                    totalSteps: 4
                )
                .padding(.top, 20)

                titleSection

                athleteSection

                genderSection
                .padding(.top, 20)

                nextButton
                    .padding(.top, 40)
            }
            .padding(.horizontal, 24)
        }
    }
}

private extension GenderSelectionView {

    var titleSection: some View {

        VStack(spacing: 8) {

            Text("Tell us about you")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.white)

            Text("help us personalize your plan")
                .font(.system(size: 16))
                .foregroundStyle(AppColors.textSecondary)
        }
        .padding(.top, 12)
    }

    var athleteSection: some View {
        Image("woman1")
               .resizable()
               .scaledToFit()
               .frame(maxWidth: .infinity)
               .frame(height: 370)
               .padding(.top, 20)
               .offset()
    }
    var genderSection: some View {

        VStack(alignment: .leading, spacing: 16) {

            Text("Your gender")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(.white)

            SelectionButton(
                title: "Male",
                isSelected: viewModel.selectedGender == .male
            ) {
                viewModel.selectedGender = .male
            }

            SelectionButton(
                title: "Female",
                isSelected: viewModel.selectedGender == .female
            ) {
                viewModel.selectedGender = .female
            }
        }
    }

    var nextButton: some View {

        PrimaryButton(
            title: "Next"
        ) {

        }
        .padding(.bottom, 0)
    }
}

#Preview {
    GenderSelectionView()
}
