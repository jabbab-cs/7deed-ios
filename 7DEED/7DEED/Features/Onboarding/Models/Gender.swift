//
//  Gender.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 21/06/2026.
//


enum Gender: String, CaseIterable, Identifiable {
    case male
    case female

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .male:   return "Male"
        case .female: return "Female"
        }
    }
}
