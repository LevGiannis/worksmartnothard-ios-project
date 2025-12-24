//
//  AppTheme.swift
//  WorkSmartNotHard
//
//  Created by Ioannis Levakos on 24/12/25.
//

import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case light
    case dark

    var id: String { rawValue }

    var titleGR: String {
        switch self {
        case .light: return "Λευκό"
        case .dark:  return "Μαύρο"
        }
    }

    var colorScheme: ColorScheme {
        switch self {
        case .light: return .light
        case .dark:  return .dark
        }
    }
}
