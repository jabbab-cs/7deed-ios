//
//  ProgressIndicator.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 21/06/2026.
//


import SwiftUI

struct ProgressIndicator: View {

    let currentStep: Int
    let totalSteps: Int

    var body: some View {
        HStack(spacing: 12) {

            ForEach(0..<totalSteps, id: \.self) { index in

                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        index < currentStep
                        ? AppColors.primary
                        : Color.white.opacity(0.35)
                    )
                    .frame(width:70,height: 8)
                    
            }
        }
    }
}
