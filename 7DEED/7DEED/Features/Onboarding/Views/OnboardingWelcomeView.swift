//
//  OnboardingWelcomeView.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 21/06/2026.
//


import SwiftUI

struct OnboardingWelcomeView: View {
    
    var body: some View {
        
        ZStack {
            
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                headerSection
                
                logoSection
                
                subtitleSection
                
                athleteSection
                
                Spacer()
                
                startButton
            }
            .padding(.horizontal, 24)
        }
    }
}

private extension OnboardingWelcomeView {
    
    var headerSection: some View {
        HStack {
            Text("Welcome to")
                .font(.custom("PlusJakartaSans-Regular_Bold", size: 22))

                .foregroundStyle(.white)
            
            Spacer()
        }
        .padding(.top, 20)
    }
    
    var logoSection: some View {
        Image("hadeed_logo")
            .resizable()
            .scaledToFit()
            .frame(height: 70)
            .padding(.top, 30)
    }
    
    var subtitleSection: some View {
        Text("Your all-in-one fitness tracker")
            .font(.custom("PlusJakartaSans-Regular_Medium", size: 22))
            .foregroundStyle(AppColors.textSecondary)
            .padding(.top, 20)
    }
    
    var athleteSection: some View {
        Image("onboarding_athlete")
            .resizable()
            .scaledToFit()
            .scaleEffect(1.22)
            .padding(.top, 50)
            .padding(.leading, 5)

    }
    
    var startButton: some View {
        PrimaryButton(
            title: "Start Your Journey"
        ) {
            
        }
        .padding(.bottom, 0)
    }
}

#Preview {
    OnboardingWelcomeView()
}
