//
//  LabeledPickerField.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 22/06/2026.
//

//  LabeledPickerField.swift — 7DEED

import SwiftUI

/// A type that can list its cases and knows how to display each one.
/// Conform any enum to this and LabeledPickerField will render a dropdown for it.
protocol Selectable: Identifiable, Hashable, CaseIterable {
    var displayName: String { get }
}

struct LabeledPickerField<Option: Selectable>: View
where Option.AllCases: RandomAccessCollection {

    let label: String
    @Binding var selection: Option

    var body: some View {
        Menu {
            ForEach(Option.allCases) { option in
                Button(option.displayName) { selection = option }
            }
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(label)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(AppColors.primary)
                    Text(selection.displayName)
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "chevron.down")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppColors.primary)
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm + 2)
            .overlay {
                RoundedRectangle(cornerRadius: AppRadius.small)
                    .stroke(AppColors.primary, lineWidth: 1)
            }
        }
    }
}
