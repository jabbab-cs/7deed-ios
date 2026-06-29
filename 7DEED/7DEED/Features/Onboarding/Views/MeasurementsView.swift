//
//  MeasurementsView.swift — 7DEED
//  Rebuilt on the TargetView pattern: pinned header → scroll → pinned button,
//  no hero. Gives the Activity Level dropdown room to expand without clipping.
//

import SwiftUI

struct MeasurementsView: View {

    @ObservedObject var viewModel: OnboardingViewModel

    @State private var heightText = ""
    @State private var weightText = ""
    @FocusState private var focusedField: Field?

    private enum Field { case height, weight }

    var body: some View {
        VStack(spacing: 0) {
            OnboardingHeader(
                progressStep: viewModel.currentStep.stepNumber,
                totalSteps: viewModel.totalSteps,
                title: "Tell us about you",
                subtitle: "Help us personalize your plan",
                showsBackButton: viewModel.canGoBack,
                onBack: viewModel.goBack
            )

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    sectionTitle("Measurements")

                    VStack(spacing: AppSpacing.md) {
                        LabeledTextField(label: "Height", placeholder: "Input", unit: "CM", text: $heightText)
                            .focused($focusedField, equals: .height)
                        LabeledTextField(label: "Weight", placeholder: "Input", unit: "KG", text: $weightText)
                            .focused($focusedField, equals: .weight)
                    }

                    sectionTitle("Activity Level")

                    DescriptivePickerField(
                        label: "Activity Level",
                        selection: $viewModel.data.activityLevel
                    )
                }
                .padding(.top, AppSpacing.md)
                .padding(.bottom, AppSpacing.md)
            }

            PrimaryButton(title: "Next",
                          isEnabled: viewModel.canProceed,
                          action: viewModel.goNext)
                .padding(.top, AppSpacing.sm)
                .padding(.bottom, AppSpacing.sm)
        }
        .padding(.horizontal, AppSpacing.lg)
        .background(AppColors.background.ignoresSafeArea())
        .onAppear(perform: seedFromModel)
        .onChange(of: heightText) { newValue in
            viewModel.data.heightCm = parse(newValue)
        }
        .onChange(of: weightText) { newValue in
            viewModel.data.weightKg = parse(newValue)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { focusedField = nil }
            }
        }
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 34, weight: .bold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Model sync

    private func seedFromModel() {
        heightText = viewModel.data.heightCm.map(format) ?? ""
        weightText = viewModel.data.weightKg.map(format) ?? ""
    }
    private func parse(_ text: String) -> Double? {
        Double(text.replacingOccurrences(of: ",", with: "."))
    }
    private func format(_ value: Double) -> String {
        value == value.rounded() ? String(Int(value)) : String(value)
    }
}

#Preview {
    MeasurementsView(viewModel: OnboardingViewModel(startingAt: .measurements))
}
