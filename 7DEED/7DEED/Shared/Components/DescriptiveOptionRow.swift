//
//  DescriptiveOptionRow.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 27/06/2026.
//


//
//  DescriptiveOptionRow.swift — 7DEED
//  A two-line selectable row: bold title with a description beneath.
//  For option lists where each choice needs a short explanation
//  (e.g. Activity Level). Presentational only — owns no state.
//

import SwiftUI

struct DescriptiveOptionRow: View {

    let title: String
    let description: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)

                Text(description)
                    .font(.system(size: 13))
                    .foregroundStyle(AppColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)   // wrap, don't clip
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm + 4)                  // ~12pt
            .background(isSelected ? AppColors.primary.opacity(0.12) : Color.clear)
            .contentShape(Rectangle())                             // whole row is tappable
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)                 // VoiceOver reads title + description
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    VStack(spacing: 0) {
        DescriptiveOptionRow(title: "Sedentary",
                             description: "Office job, little to no exercise",
                             isSelected: true) {}
        DescriptiveOptionRow(title: "Lightly Active",
                             description: "Light exercise or sports 1–3 days a week",
                             isSelected: false) {}
    }
    .background(AppColors.background)
}
