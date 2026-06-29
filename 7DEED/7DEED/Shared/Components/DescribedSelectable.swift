//
//  DescribedSelectable.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 27/06/2026.
//


//
//  DescriptivePickerField.swift — 7DEED
//  A collapsible dropdown: collapsed shows the selected value; tapping
//  expands a list where each option has a title and a description beneath.
//  Used for choices that need a short explanation (e.g. Activity Level).
//
//  Native Picker/Menu can't show two-line rows, so this is custom — but it
//  reuses the bordered-field look + selection tint already in the app.
//

import SwiftUI

/// A `Selectable` that also carries a one-line explanation for each case.
protocol DescribedSelectable: Selectable {
    var description: String { get }
}

// ActivityLevel already exposes `displayName` (Selectable) and `description`,
// so it satisfies this with an empty conformance.
extension ActivityLevel: DescribedSelectable {}

struct DescriptivePickerField<Option: DescribedSelectable>: View
where Option.AllCases: RandomAccessCollection {

    let label: String
    @Binding var selection: Option

    @State private var isExpanded = false

    var body: some View {
        VStack(spacing: 0) {
            header

            if isExpanded {
                Rectangle()
                    .fill(Color.white.opacity(0.10))
                    .frame(height: 1)
                optionsList
                    .background(AppColors.surface)   // dark panel behind the list
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.small))  // tint never escapes corners
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.small)
                .stroke(AppColors.primary, lineWidth: 1)
        }
        .animation(.easeInOut(duration: 0.2), value: isExpanded)
    }

    // MARK: - Collapsed field

    private var header: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) { isExpanded.toggle() }
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
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm + 2)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Expanded list

    private var optionsList: some View {
        VStack(spacing: 0) {
            ForEach(Array(Option.allCases.enumerated()), id: \.element.id) { index, option in
                if index > 0 {
                    Rectangle()
                        .fill(Color.white.opacity(0.06))
                        .frame(height: 1)
                }
                DescriptivePickerRow(
                    title: option.displayName,
                    description: option.description,
                    isSelected: selection == option
                ) {
                    selection = option
                    withAnimation(.easeInOut(duration: 0.2)) { isExpanded = false }
                }
            }
        }
    }
}

// MARK: - Row (file-private; only this picker uses it)

private struct DescriptivePickerRow: View {

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
            .padding(.vertical, AppSpacing.sm + 4)
            .background(isSelected ? AppColors.primary.opacity(0.12) : Color.clear)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    struct Demo: View {
        @State private var level: ActivityLevel = .sedentary
        var body: some View {
            DescriptivePickerField(label: "Activity Level", selection: $level)
                .padding()
                .background(AppColors.background)
        }
    }
    return Demo()
}
