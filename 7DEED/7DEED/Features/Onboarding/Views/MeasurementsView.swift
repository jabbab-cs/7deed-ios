//
//  MeasurementsView.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 22/06/2026.
//


//  MeasurementsView.swift — 7DEED

import SwiftUI

struct MeasurementsView: View {

    @ObservedObject var viewModel: OnboardingViewModel

    @State private var heightText = ""
    @State private var weightText = ""
    @FocusState private var focusedField: Field?

    private enum Field { case height, weight }

    var body: some View {
        OnboardingScaffold(
            progressStep: viewModel.currentStep.stepNumber,
            totalSteps: OnboardingStep.totalSteps,
            showsBackButton: viewModel.canGoBack,
            isNextEnabled: viewModel.canProceed,
            imageName: "man2",            // ⚠️ replace with YOUR actual asset name
            imageScale: 1.2,              // tune in canvas
            imageOffset: CGSize(width: 0, height: 15),
            imagePosition: .bottom,       // image sits below the inputs
            onBack: viewModel.goBack,
            onNext: viewModel.goNext
        ) {
            content
        }
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

    private var content: some View {
        VStack(alignment: .leading, spacing: AppSpacing.lg) {
            sectionTitle("Measurements")

            VStack(spacing: AppSpacing.md) {
                LabeledTextField(label: "Height", placeholder: "Input", unit: "CM", text: $heightText)
                    .focused($focusedField, equals: .height)
                LabeledTextField(label: "Weight", placeholder: "Input", unit: "KG", text: $weightText)
                    .focused($focusedField, equals: .weight)
            }

            sectionTitle("Activity Level")

            LabeledPickerField(label: "Activity Level", selection: $viewModel.data.activityLevel)
        }
        .padding(.top, AppSpacing.md)
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
