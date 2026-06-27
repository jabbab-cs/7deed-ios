//
//  RateOptionCard.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 23/06/2026.
//


//  RateOptionCard.swift — 7DEED

import SwiftUI

struct RateOptionCard: View {
    let rateText: String      // "0.25"
    let unit: String          // "kg/wk"
    let title: String
    let subtitle: String
    let isSelected: Bool
    let isRecommended: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                ratePill
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundStyle(AppColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 8)
                RadioIndicator(isSelected: isSelected)
            }
            .padding(AppSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: AppRadius.medium)
                    .fill(isSelected ? AppColors.primary.opacity(0.15) : AppColors.surface)
            )
            .overlay {
                RoundedRectangle(cornerRadius: AppRadius.medium)
                    .stroke(isSelected ? AppColors.primary : Color.white.opacity(0.12),
                            lineWidth: isSelected ? 2 : 1)
            }
            .overlay(alignment: .topTrailing) {
                if isRecommended {
                    Text("Recommended")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(AppColors.primary))
                        .offset(x: -AppSpacing.md, y: -9)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var ratePill: some View {
        VStack(spacing: 0) {
            Text(rateText).font(.system(size: 16, weight: .bold)).foregroundStyle(.white)
            Text(unit).font(.system(size: 9, weight: .medium)).foregroundStyle(.white.opacity(0.85))
        }
        .frame(width: 52, height: 46)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.small)
                .fill(isSelected ? AppColors.primary : AppColors.primary.opacity(0.25))
        )
    }
}
