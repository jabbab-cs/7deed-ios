//
//  SelectionButton.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 21/06/2026.
//


import SwiftUI

struct SelectionButton: View {

    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {

        Button(action: action) {

            HStack(spacing: 12) {

                Circle()
                    .fill(
                        isSelected
                        ? AppColors.primary
                        : Color.clear
                    )
                    .frame(width: 12, height: 12)
                    .padding(4)
                    .overlay {
                        Circle()
                            .stroke(
                                AppColors.primary,
                                lineWidth: 2
                            )
                    }

                Text(title)
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .semibold))

                Spacer()
            }
            .padding()
            .frame(height: 56)
            .background(
                isSelected
                ? AppColors.primary.opacity(0.12)
                : Color.clear
            )
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        AppColors.primary,
                        lineWidth: isSelected ? 2 : 1
                    )
            }
        }
    }
}
