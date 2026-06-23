//
//  PrimaryButton.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 21/06/2026.
//




import SwiftUI

struct PrimaryButton: View {

    let title: String
    var isEnabled: Bool = true          // defaults true → existing call sites still compile
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(AppGradients.primaryButton)
                .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.45)
        .animation(.easeInOut(duration: 0.15), value: isEnabled)
    }
}
