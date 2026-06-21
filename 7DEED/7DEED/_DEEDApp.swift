//
//  _DEEDApp.swift
//  7DEED
//
//  Created by Mohammad Jarrar on 21/06/2026.
//

import SwiftUI
import UIKit

@main
struct _DEEDApp: App {

    init() {
        print("========== FONTS ==========")

        for family in UIFont.familyNames.sorted() {
            print("Family: \(family)")

            for font in UIFont.fontNames(forFamilyName: family) {
                print("   \(font)")
            }
        }

        print("========== END ==========")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
