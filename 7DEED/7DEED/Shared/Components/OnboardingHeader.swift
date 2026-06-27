//
//  OnboardingHeader.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 23/06/2026.
//


//  OnboardingHeader.swift — 7DEED
//  Progress bar + title + subtitle + optional back chevron.
//  Shared by OnboardingScaffold and by screens that roll their own layout (e.g. TargetView).

import SwiftUI

struct OnboardingHeader: View {
    let progressStep: Int
    let totalSteps: Int
    let title: String
    let subtitle: String
    let showsBackButton: Bool
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            ProgressIndicator(currentStep: progressStep, totalSteps: totalSteps)
                .padding(.top, AppSpacing.md)

            ZStack {
                Text(title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                if showsBackButton {
                    HStack {
                        Button(action: onBack) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundStyle(AppColors.primary)
                        }
                        .buttonStyle(.plain)
                        Spacer()
                    }
                }
            }
            .padding(.top, AppSpacing.md)

            Text(subtitle)
                .font(.system(size: 16))
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
    }
}
