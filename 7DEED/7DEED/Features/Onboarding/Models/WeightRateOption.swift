//
//  WeightRateOption.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 23/06/2026.
//


//  WeightRateOption.swift — 7DEED
//  Presentational rate options only. No science here — flat data per the frontend phase.

struct WeightRateOption: Identifiable, Equatable {
    let rate: Double          // 0.25, 0.5, ...
    let title: String         // "Gentle Cut"
    let subtitle: String
    let isRecommended: Bool
    var id: Double { rate }
}

enum WeightRateCatalog {

    static func options(for goal: FitnessGoal) -> [WeightRateOption] {
        switch goal {
        case .loseFat:
            return [
                .init(rate: 0.25, title: "Gentle Cut",
                      subtitle: "Easier to sustain, minimal muscle loss", isRecommended: false),
                .init(rate: 0.5,  title: "Optimal Cut",
                      subtitle: "Best balance of speed & muscle retention", isRecommended: true),
                .init(rate: 0.75, title: "Aggressive Cut",
                      subtitle: "Faster results, requires strict adherence", isRecommended: false),
            ]
        case .gainMuscle:
            return [
                .init(rate: 0.2,  title: "Lean Bulk",
                      subtitle: "Slow & steady gains with minimal fat accumulation", isRecommended: true),
                .init(rate: 0.4,  title: "Standard Bulk",
                      subtitle: "Faster muscle growth, slight fat gain expected", isRecommended: false),
            ]
        case .maintainWeight:
            return []
        }
    }

    static func sectionTitle(for goal: FitnessGoal) -> String {
        switch goal {
        case .loseFat:        return "Weekly fat-loss rate"
        case .gainMuscle:     return "Weekly weight gain rate"
        case .maintainWeight: return ""
        }
    }
}
