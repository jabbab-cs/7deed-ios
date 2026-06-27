//  OnboardingScaffold.swift — 7DEED

import SwiftUI

enum OnboardingImagePosition { case top, bottom }

struct OnboardingScaffold<Content: View>: View {

    let progressStep: Int
    let totalSteps: Int
    let showsBackButton: Bool
    let isNextEnabled: Bool

    var title: String = "Tell us about you"
    var subtitle: String = "Help us personalize your plan"
    var nextButtonTitle: String = "Next"

    let imageName: String
    var imageScale: CGFloat = 1
    var imageOffset: CGSize = .zero
    var imagePosition: OnboardingImagePosition = .top

    let onBack: () -> Void
    let onNext: () -> Void
    @ViewBuilder let content: () -> Content

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                OnboardingHeader(
                    progressStep: progressStep,
                    totalSteps: totalSteps,
                    title: title,
                    subtitle: subtitle,
                    showsBackButton: showsBackButton,
                    onBack: onBack
                )

                if imagePosition == .top {
                    heroImage
                    content()
                } else {
                    content()
                    heroImage
                }

                PrimaryButton(title: nextButtonTitle, isEnabled: isNextEnabled, action: onNext)
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
}
