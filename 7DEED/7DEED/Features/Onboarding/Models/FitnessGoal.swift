//
//  FitnessGoal.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 23/06/2026.
//


//  FitnessGoal.swift — 7DEED

enum FitnessGoal: String, CaseIterable, Identifiable, Selectable {
    case loseFat
    case gainMuscle
    case maintainWeight

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .loseFat:        return "Lose Fat"
        case .gainMuscle:     return "Gain Muscle"
        case .maintainWeight: return "Maintain Weight"
        }
    }
}
