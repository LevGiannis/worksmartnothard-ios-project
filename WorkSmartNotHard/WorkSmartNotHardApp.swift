//
//  WorkSmartNotHardApp.swift
//  WorkSmartNotHard
//
//  Created by Ioannis Levakos on 24/12/25.
//

import SwiftUI
import SwiftData

@main
struct WorkSmartNotHardApp: App {
    @AppStorage("appTheme") private var appThemeRaw: String = AppTheme.light.rawValue
    @AppStorage("accentColor") private var accentColorRaw: String = AccentColorOption.blue.rawValue

    private var theme: AppTheme {
        AppTheme(rawValue: appThemeRaw) ?? .light
    }
    private var accentColor: Color {
        AccentColorOption(rawValue: accentColorRaw)?.color ?? .blue
    }

    var body: some Scene {
        WindowGroup {
            AppEntryView()
                .preferredColorScheme(theme.colorScheme)
                .accentColor(accentColor)
        }
        .modelContainer(for: [
            UserProfile.self,
            AppCategory.self,
            MonthPlan.self,
            Goal.self,
            DailyRecord.self,
            DailyValue.self,
            PendingCustomerTask.self
        ])
    }
}
