//
//  PrimaryButton.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 21/06/2026.
//


import SwiftUI

struct PrimaryButton: View {
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    LinearGradient(
                        colors: [
                            Color(hex: "#7C3AED"),
                            Color(hex: "#A855F7")
                        ],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 18)
                )
        }
    }
}

