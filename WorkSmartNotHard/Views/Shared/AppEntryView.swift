//
//  AppEntryView.swift
//  WorkSmartNotHard
//
//  Created by Ioannis Levakos on 24/12/25.
//

import SwiftUI
import SwiftData

struct AppEntryView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \UserProfile.createdAt, order: .reverse) private var profiles: [UserProfile]
    @Query(sort: \AppCategory.sortOrder) private var categories: [AppCategory]

    var body: some View {
        Group {
            if let profile = profiles.first {
                HomeView(profile: profile)
            } else {
                OnboardingView()
            }
        }
        .task {
            seedDefaultCategoriesIfNeeded()
        }
    }

    private func seedDefaultCategoriesIfNeeded() {
        guard categories.isEmpty else { return }

        let defaults = [
            "PortIN mobile",
            "Exprepay",
            "FWA",
            "Vodafone Home W/F",
            "Migration FTTH",
            "Post2post",
            "Ec2post",
            "First",
            "New Connection",
            "Ραντεβού",
            "Συσκευές",
            "TV",
            "Migration VDSL"
        ]

        for (i, name) in defaults.enumerated() {
            modelContext.insert(AppCategory(name: name, isActive: true, sortOrder: i))
        }
    }
}
