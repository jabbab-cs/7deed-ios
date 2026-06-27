//
//  OnboardingWelcomeView.swift
//  7DEED
//

import SwiftUI

struct OnboardingWelcomeView: View {

    var onStart: () -> Void = {}

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    Text("Welcome to")
                        .font(.custom("PlusJakartaSans-Regular", size: 22))   // real PostScript name
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(.top, 20)

                Image("hadeed_logo").resizable().scaledToFit().frame(height: 70).padding(.top, 30)

                Text("Your all-in-one fitness tracker")
                    .font(.custom("PlusJakartaSans-Regular", size: 22))
                    .fontWeight(.medium)
                    .foregroundStyle(AppColors.textSecondary)
                    .padding(.top, 20)

                Image("onboarding_athlete")
                    .resizable().scaledToFit().scaleEffect(1.22)
                    .padding(.top, 50).padding(.leading, 5)

                Spacer()
                PrimaryButton(title: "Start Your Journey", action: onStart)
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview { OnboardingWelcomeView() }
