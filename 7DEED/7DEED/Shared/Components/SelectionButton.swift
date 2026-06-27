//
//  SelectionButton.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 21/06/2026.
//

//
//  SelectionButton.swift
//  7DEED
//

import SwiftUI

struct SelectionButton: View {

    enum IndicatorPosition { case leading, trailing }

    let title: String
    let isSelected: Bool
    var indicatorPosition: IndicatorPosition = .leading
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if indicatorPosition == .leading {
                    RadioIndicator(isSelected: isSelected); label; Spacer(minLength: 0)
                } else {
                    label; Spacer(minLength: 0); RadioIndicator(isSelected: isSelected)
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? AppColors.primary.opacity(0.12) : Color.clear)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.primary, lineWidth: isSelected ? 2 : 1)
            }
        }
        .buttonStyle(.plain)
    }

    private var label: some View {
        Text(title)
            .foregroundStyle(.white)
            .font(.system(size: 18, weight: .semibold))
    }
}
