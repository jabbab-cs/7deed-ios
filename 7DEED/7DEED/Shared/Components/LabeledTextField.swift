//
//  LabeledTextField.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 22/06/2026.
//


//  LabeledTextField.swift — 7DEED

import SwiftUI

struct LabeledTextField: View {

    let label: String
    let placeholder: String
    let unit: String?
    @Binding var text: String
    var keyboardType: UIKeyboardType = .decimalPad

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(label)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(AppColors.primary)
                TextField(placeholder, text: $text)
                    .font(.system(size: 18))
                    .foregroundStyle(.white)
                    .tint(AppColors.primary)
                    .keyboardType(keyboardType)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if let unit {
                Text(unit)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(AppColors.primary)
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm + 2)
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.small)
                .stroke(AppColors.primary, lineWidth: 1)
        }
    }
}
