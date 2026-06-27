//
//  RadioIndicator.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 23/06/2026.
//


//  RadioIndicator.swift — 7DEED

import SwiftUI

struct RadioIndicator: View {
    let isSelected: Bool

    var body: some View {
        Circle()
            .fill(isSelected ? AppColors.primary : Color.clear)
            .frame(width: 12, height: 12)
            .padding(4)
            .overlay { Circle().stroke(AppColors.primary, lineWidth: 2) }
    }
}
