//
//  OnboardingData.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 21/06/2026.
//


import Foundation

struct OnboardingData {
    var gender: Gender?
    var dateOfBirth: Date?
    var heightCm: Double?
    var weightKg: Double?
    var activityLevel: ActivityLevel = .sedentary   // matches the design's default
    // var goal: FitnessGoal?   // added when we build the Goal screen

    var age: Int? {
        guard let dob = dateOfBirth else { return nil }
        return Calendar.current.dateComponents([.year], from: dob, to: .now).year
    }
}
