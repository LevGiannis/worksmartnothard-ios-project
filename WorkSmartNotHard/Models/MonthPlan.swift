//
//  MonthPlan.swift
//  WorkSmartNotHard
//
//  Created by Ioannis Levakos on 24/12/25.
//

import Foundation
import SwiftData

@Model
final class MonthPlan {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var monthKey: String   // ✅ 1 plan ανά μήνα
    var monthStart: Date
    var createdAt: Date

    @Relationship(deleteRule: .cascade) var goals: [Goal] = []
    @Relationship(deleteRule: .cascade) var records: [DailyRecord] = []

    init(monthStart: Date) {
        let ms = monthStart.startOfMonth
        self.id = UUID()
        self.monthStart = ms
        self.monthKey = ms.monthKey
        self.createdAt = Date()
    }
}
