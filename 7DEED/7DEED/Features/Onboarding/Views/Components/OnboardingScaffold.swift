//
//  OnboardingScaffold.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 21/06/2026.
//


//  OnboardingScaffold.swift — 7DEED

//  OnboardingScaffold.swift — 7DEED

//  OnboardingScaffold.swift — 7DEED

import SwiftUI

enum OnboardingImagePosition { case top, bottom }

struct OnboardingScaffold<Content: View>: View {

    let progressStep: Int
    let totalSteps: Int
    let showsBackButton: Bool
    let isNextEnabled: Bool

    let imageName: String
    var imageScale: CGFloat = 1
    var imageOffset: CGSize = .zero
    var imagePosition: OnboardingImagePosition = .top   // NEW (defaults keep old screens intact)

    let onBack: () -> Void
    let onNext: () -> Void
    @ViewBuilder let content: () -> Content

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                ProgressIndicator(currentStep: progressStep, totalSteps: totalSteps)
                    .padding(.top, AppSpacing.md)

                header

                if imagePosition == .top {
                    heroImage
                    content()
                } else {
                    content()
                    heroImage
                }

                PrimaryButton(title: "Next", isEnabled: isNextEnabled, action: onNext)
                    .padding(.top, AppSpacing.lg)
                    .padding(.bottom, AppSpacing.sm)
            }
            .padding(.horizontal, AppSpacing.lg)
        }
    }

    private var heroImage: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .scaleEffect(imageScale)
            .offset(imageOffset)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var header: some View {
        VStack(spacing: AppSpacing.sm) {
            ZStack {
                Text("Tell us about you")
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
            Text("Help us personalize your plan")
                .font(.system(size: 16))
                .foregroundStyle(AppColors.textSecondary)
        }
        .padding(.top, AppSpacing.md)
    }
}
