//  BirthdaySelectionView.swift — 7DEED

import SwiftUI

struct BirthdaySelectionView: View {

    @ObservedObject var viewModel: OnboardingViewModel

    private static let minimumAge = 13
    private static let maximumAge = 100

    var body: some View {
        OnboardingScaffold(
            progressStep: viewModel.currentStep.stepNumber,
            totalSteps: OnboardingStep.totalSteps,
            showsBackButton: viewModel.canGoBack,
            isNextEnabled: viewModel.canProceed,
            imageName: "man1",
            imageScale: 2.1,                          // ← fills the frame; tune to taste
            imageOffset: CGSize(width: 20, height:150),  // ← nudge if the hat clips the header
            onBack: viewModel.goBack,
            onNext: viewModel.goNext
        ) {
            birthdaySection
        }
        .onAppear(perform: seedDefaultDateIfNeeded)
    }

    private var birthdaySection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Your Birthday")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            DatePicker(
                "Your Birthday",
                selection: dateOfBirthBinding,
                in: Self.dateRange,
                displayedComponents: .date
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .colorScheme(.dark)
            .frame(maxWidth: .infinity)
        }
        .padding(.top, AppSpacing.md)
    }

    private var dateOfBirthBinding: Binding<Date> {
        Binding(
            get: { viewModel.data.dateOfBirth ?? Self.defaultDate },
            set: { viewModel.data.dateOfBirth = $0 }
        )
    }

    private func seedDefaultDateIfNeeded() {
        if viewModel.data.dateOfBirth == nil {
            viewModel.data.dateOfBirth = Self.defaultDate
        }
    }

    private static func date(yearsAgo years: Int) -> Date {
        Calendar.current.date(byAdding: .year, value: -years, to: .now) ?? .now
    }
    private static var defaultDate: Date { date(yearsAgo: 18) }
    private static var dateRange: ClosedRange<Date> {
        date(yearsAgo: maximumAge)...date(yearsAgo: minimumAge)
    }
}

#Preview {
    // Seed the VM to the birthday step so back button + Next behave correctly.
    BirthdaySelectionView(viewModel: OnboardingViewModel(startingAt: .birthday))
}
