//
//  WeightScaleSlider.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 23/06/2026.
//


//  WeightScaleSlider.swift — 7DEED
//  Horizontal ruler: fixed ticks + moving needle + big readout. Snaps in `step`, haptic per snap.

import SwiftUI
import UIKit

struct WeightScaleSlider: View {

    @Binding var value: Double
    let range: ClosedRange<Double>
    var step: Double = 0.5
    var minorTickEvery: Int = 1
    var majorTickEvery: Int = 5
    var unit: String = "Kg"

    private let inset: CGFloat = 20
    private let haptic = UIImpactFeedbackGenerator(style: .light)
    @State private var lastSnapped: Double = .nan

    var body: some View {
        VStack(spacing: AppSpacing.md) {
            Text("\(formatted(value)) \(unit)")
                .font(.system(size: 56, weight: .heavy))
                .monospacedDigit()
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)

            GeometryReader { geo in
                ZStack(alignment: .topLeading) {
                    Canvas { context, size in
                        let lower = Int(range.lowerBound.rounded(.up))
                        let upper = Int(range.upperBound.rounded(.down))
                        for t in stride(from: lower, through: upper, by: minorTickEvery) {
                            let xPos = x(for: Double(t), width: size.width)
                            let isMajor = majorTickEvery > 0 && t % majorTickEvery == 0
                            let height: CGFloat = isMajor ? 26 : 14
                            var line = Path()
                            line.move(to: CGPoint(x: xPos, y: 6))
                            line.addLine(to: CGPoint(x: xPos, y: 6 + height))
                            context.stroke(
                                line,
                                with: .color(AppColors.primary.opacity(isMajor ? 0.55 : 0.28)),
                                lineWidth: isMajor ? 2 : 1
                            )
                            if isMajor {
                                context.draw(
                                    Text("\(t)").font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.white.opacity(0.55)),
                                    at: CGPoint(x: xPos, y: 48), anchor: .center
                                )
                            }
                        }
                    }

                    Capsule()
                        .fill(AppColors.primary)
                        .frame(width: 4, height: 34)
                        .shadow(color: AppColors.primary.opacity(0.6), radius: 6)
                        .position(x: x(for: value, width: geo.size.width), y: 23)
                }
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { update(toX: $0.location.x, width: geo.size.width) }
                        .onEnded { _ in lastSnapped = .nan }
                )
                .onAppear { haptic.prepare() }
            }
            .frame(height: 64)
        }
    }

    private func x(for v: Double, width: CGFloat) -> CGFloat {
        let usable = width - inset * 2
        let ratio = (v - range.lowerBound) / (range.upperBound - range.lowerBound)
        return inset + usable * CGFloat(ratio)
    }

    private func update(toX px: CGFloat, width: CGFloat) {
        let usable = width - inset * 2
        let ratio = max(0, min(1, Double((px - inset) / usable)))
        let raw = range.lowerBound + ratio * (range.upperBound - range.lowerBound)
        let snapped = min(range.upperBound, max(range.lowerBound, (raw / step).rounded() * step))
        if snapped != value { value = snapped }
        if snapped != lastSnapped {
            lastSnapped = snapped
            haptic.impactOccurred(intensity: 0.6)
            haptic.prepare()
        }
    }

    private func formatted(_ v: Double) -> String { String(format: "%g", v) }
}
