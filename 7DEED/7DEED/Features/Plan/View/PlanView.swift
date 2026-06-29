//
//  PlanView.swift — 7DEED
//  The "Daily Breakdown" plan screen shown after onboarding.
//

import SwiftUI

struct PlanView: View {

    @StateObject private var viewModel: PlanViewModel
    var onBack: (() -> Void)? = nil
    var onTrack: () -> Void = {}

    private let background = Color(hex: "#0E071F")
    private let tileFill = Color(hex: "#211036")
    private let purple = Color(hex: "#9B6CFF")
    private let softPurple = Color(hex: "#B28BFF")
    private let mutedText = Color(hex: "#A895C6")
    private let proteinColor = Color(hex: "#0D90C0")
    private let carbColor = Color(hex: "#3B8341")
    private let fatColor = Color(hex: "#FFF432")
    private let proteinGradient = LinearGradient(
        colors: [Color(hex: "#0D90C0"), Color(hex: "#5DD4E2")],
        startPoint: .leading,
        endPoint: .trailing
    )
    private let carbGradient = LinearGradient(
        colors: [Color(hex: "#3B8341"), Color(hex: "#71CA76")],
        startPoint: .leading,
        endPoint: .trailing
    )
    private let fatGradient = LinearGradient(
        colors: [Color(hex: "#FFF432"), Color(hex: "#DEE3A0")],
        startPoint: .leading,
        endPoint: .trailing
    )

    init(plan: NutritionPlan, onBack: (() -> Void)? = nil, onTrack: @escaping () -> Void = {}) {
        _viewModel = StateObject(wrappedValue: PlanViewModel(plan: plan))
        self.onBack = onBack
        self.onTrack = onTrack
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Daily Breakdown")
                        .font(.system(size: 34, weight: .heavy))
                        .foregroundStyle(.white)
                        .padding(.top, 14)

                    caloriesCard
                    macrosCard

                    Text("Plan Summary")
                        .font(.system(size: 34, weight: .heavy))
                        .foregroundStyle(.white)
                        .padding(.top, 24)

                    summaryCard
                    highlightsRow
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 16)
            }

            Button(action: onTrack) {
                Text("Let’s Track")
                    .font(.system(size: 19, weight: .heavy))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "#8D39F5"), Color(hex: "#AE4CFA")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .buttonStyle(.plain)
            .disabled(!viewModel.isValidForTracking)
            .opacity(viewModel.isValidForTracking ? 1 : 0.5)
            .padding(.horizontal, 28)
            .padding(.top, 4)
            .padding(.bottom, 40)
        }
        .background(background.ignoresSafeArea())
    }

    private var header: some View {
        ZStack {
            HStack(spacing: 7) {
                Text("PLAN READY")
                    .font(.system(size: 15, weight: .heavy))
                    .tracking(0.4)
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 13, weight: .bold))
            }
            .foregroundStyle(purple)
            .padding(.horizontal, 13)
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(hex: "#211038"))
            )

            HStack {
                Button(action: { onBack?() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 23, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 34, height: 40, alignment: .leading)
                }
                .buttonStyle(.plain)
                .opacity(onBack == nil ? 0 : 1)
                .disabled(onBack == nil)

                Spacer()
            }
        }
        .padding(.horizontal, 28)
        .padding(.top, 26)
    }

    private var caloriesCard: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("DAILY CALORIES")
                    .font(.system(size: 11, weight: .heavy))
                    .tracking(1.6)
                    .foregroundStyle(mutedText)

                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    Text("\(viewModel.plan.targetCalories.formatted())")
                        .font(.system(size: 55, weight: .heavy))
                        .foregroundStyle(.white)
                        .minimumScaleFactor(0.75)
                        .lineLimit(1)

                    Text("kcal / day")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(mutedText)
                        .lineLimit(1)
                }
            }

            Spacer(minLength: 6)

            Image(systemName: "flame.fill")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(purple)
                .frame(width: 42)
        }
        .padding(.horizontal, 22)
        .frame(height: 118)
        .planCardBorder()
    }

    private var macrosCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                Text("DAILY MACROS")
                    .font(.system(size: 11, weight: .heavy))
                    .tracking(1.6)
                    .foregroundStyle(mutedText)

                Spacer()

                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.isEditing.toggle()
                    }
                } label: {
                    HStack(spacing: 5) {
                        Text("Edit")
                        Image(systemName: "pencil")
                            .font(.system(size: 10, weight: .heavy))
                    }
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 11)
                    .frame(height: 29)
                    .background(
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .fill(purple)
                    )
                }
                .buttonStyle(.plain)
                .offset(x: 22, y: -1)
            }

            HStack(spacing: 12) {
                macroTile(
                    title: "Protein",
                    grams: viewModel.macros.proteinGrams,
                    kcal: viewModel.macros.proteinCalories,
                    asset: "protein",
                    tint: proteinColor,
                    gradient: proteinGradient,
                    set: viewModel.setProtein
                )

                macroTile(
                    title: "Carbs",
                    grams: viewModel.macros.carbGrams,
                    kcal: viewModel.macros.carbCalories,
                    asset: "carbs",
                    tint: carbColor,
                    gradient: carbGradient,
                    set: viewModel.setCarbs
                )

                macroTile(
                    title: "Fats",
                    grams: viewModel.macros.fatGrams,
                    kcal: viewModel.macros.fatCalories,
                    asset: "fats",
                    tint: fatColor,
                    gradient: fatGradient,
                    set: viewModel.setFat
                )
            }

            if viewModel.isEditing {
                editorFooter
                    .padding(.top, 2)
            }
        }
        .padding(.horizontal, 22)
        .padding(.top, 22)
        .padding(.bottom, 23)
        .planCardBorder()
    }

    private func macroTile(
        title: String,
        grams: Int,
        kcal: Int,
        asset: String,
        tint: Color,
        gradient: LinearGradient,
        set: @escaping (Int) -> Void
    ) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(mutedText)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            VStack(spacing: 7) {
                Image(asset)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .foregroundStyle(tint)
                    .frame(width: 32, height: 34)

                Text("\(grams)g")
                    .font(.system(size: 17, weight: .heavy))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Text("\(viewModel.percent(ofCalories: kcal))%")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(mutedText)

                if viewModel.isEditing {
                    HStack(spacing: 10) {
                        macroAdjustButton(systemName: "minus") {
                            set(max(0, grams - 1))
                        }

                        macroAdjustButton(systemName: "plus") {
                            set(min(999, grams + 1))
                        }
                    }
                    .frame(height: 24)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: viewModel.isEditing ? 130 : 107)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(tileFill)
            )
            .overlay {
                MacroTileUnderline(curveHeight: 11, thickness: 3)
                    .fill(gradient)
                    .padding(.horizontal, 1.5)
            }
        }
    }

    private func macroAdjustButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 11, weight: .heavy))
                .foregroundStyle(.white)
                .frame(width: 24, height: 24)
                .background(
                    Circle()
                        .fill(purple)
                )
        }
        .buttonStyle(.plain)
    }

    private var editorFooter: some View {
        VStack(spacing: 10) {
            validationBanner

            HStack {
                Button("Auto-balance", action: viewModel.autoBalance)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(purple)

                Spacer()

                Button("Reset", action: viewModel.resetToDefault)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(mutedText)
            }
        }
    }

    @ViewBuilder private var validationBanner: some View {
        let (text, color): (String, Color) = {
            switch viewModel.validation {
            case .valid:
                return ("On target", carbColor)
            case .underTarget(let remaining):
                return ("\(remaining) kcal under target", mutedText)
            case .overTarget(let excess):
                return ("\(excess) kcal over target", AppColors.error)
            case .invalidInput:
                return ("Invalid value", AppColors.error)
            }
        }()

        Text(text)
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(color)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var summaryCard: some View {
        VStack(spacing: 15) {
            HStack(alignment: .top, spacing: 24) {
                summaryItem("GOAL", viewModel.plan.direction.summaryLabel)
                summaryItem("GOAL", rateText)
            }

            HStack(spacing: 24) {
                Rectangle()
                    .fill(softPurple.opacity(0.28))
                    .frame(height: 1)
                Rectangle()
                    .fill(softPurple.opacity(0.28))
                    .frame(height: 1)
            }

            HStack(alignment: .top, spacing: 24) {
                summaryItem("TARGET", targetWeightText)
                summaryItem("TIMELINE", timelineText)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 21)
        .planCardBorder()
    }

    private func summaryItem(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(mutedText)

            Text(value)
                .font(.system(size: 16, weight: .heavy))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var highlightsRow: some View {
        HStack(spacing: 0) {
            ForEach(Array(highlights.enumerated()), id: \.offset) { index, item in
                HStack(alignment: .top, spacing: 4) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .heavy))
                    Text(item)
                        .font(.system(size: 13, weight: .medium))
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .foregroundStyle(mutedText)
                .frame(maxWidth: .infinity, minHeight: 40)

                if index < highlights.count - 1 {
                    Rectangle()
                        .fill(softPurple.opacity(0.33))
                        .frame(width: 1, height: 36)
                }
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 68)
        .planCardBorder()
    }

    private var rateText: String {
        viewModel.plan.direction == .maintenance
            ? "—"
            : "\(String(format: "%g", viewModel.plan.weeklyRateKg)) kg/wk"
    }

    private var targetWeightText: String {
        guard let target = viewModel.plan.targetWeightKg else { return "—" }
        return "\(String(format: "%g", target)) kg"
    }

    private var timelineText: String {
        guard let weeks = viewModel.plan.estimatedWeeks else { return "—" }
        return "\(weeks) weeks"
    }

    private var highlights: [String] {
        switch viewModel.plan.direction {
        case .cutting:
            return ["Optimized\nprotein", "Preserves\nmuscle", "Sustainable\ndeficit"]
        case .bulking:
            return ["Optimized\nprotein", "Lean\nsurplus", "Steady\ngains"]
        case .maintenance:
            return ["Optimized\nprotein", "Balanced\nmacros", "Steady\nenergy"]
        }
    }
}

private extension View {
    func planCardBorder() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(hex: "#17092A"))
            )
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color(hex: "#A879FF"), lineWidth: 2)
            }
    }
}

private struct MacroTileUnderline: Shape {
    let curveHeight: CGFloat
    let thickness: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let curve = min(curveHeight, rect.width / 3)
        let bottom = rect.maxY - 1
        let top = bottom - curve
        let innerBottom = bottom - thickness

        path.move(to: CGPoint(x: rect.minX, y: top))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + curve, y: bottom),
            control: CGPoint(x: rect.minX, y: bottom)
        )
        path.addLine(to: CGPoint(x: rect.maxX - curve, y: bottom))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: top),
            control: CGPoint(x: rect.maxX, y: bottom)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - curve, y: innerBottom),
            control: CGPoint(x: rect.maxX, y: innerBottom)
        )
        path.addLine(to: CGPoint(x: rect.minX + curve, y: innerBottom))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: top),
            control: CGPoint(x: rect.minX, y: innerBottom)
        )
        path.closeSubpath()

        return path
    }
}

#Preview {
    let input = PlanInput(sex: .male, currentWeightKg: 85, targetWeightKg: 75,
                          heightCm: 180, age: 25, activityLevel: .moderate, weeklyRateKg: 0.5)
    return PlanView(plan: NutritionCalculator.makePlan(input))
}
