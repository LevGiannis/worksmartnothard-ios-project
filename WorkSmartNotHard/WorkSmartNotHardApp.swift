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

    private var theme: AppTheme {
        AppTheme(rawValue: appThemeRaw) ?? .light
    }

    var body: some Scene {
        WindowGroup {
            AppEntryView()
                .preferredColorScheme(theme.colorScheme)   // ✅ force Light/Dark
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
