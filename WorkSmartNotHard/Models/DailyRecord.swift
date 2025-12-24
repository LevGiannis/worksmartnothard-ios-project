//
//  DailyRecord.swift
//  WorkSmartNotHard
//
//  Created by Ioannis Levakos on 24/12/25.
//

import Foundation
import SwiftData

@Model
final class DailyRecord {
    @Attribute(.unique) var id: UUID
    var date: Date
    var createdAt: Date

    @Relationship(deleteRule: .cascade) var values: [DailyValue] = []

    init(date: Date) {
        self.id = UUID()
        self.date = date
        self.createdAt = Date()
    }
}

@Model
final class DailyValue {
    @Attribute(.unique) var id: UUID
    var categoryId: UUID
    var categoryName: String
    var value: Int
    var subtype: String?

    init(categoryId: UUID, categoryName: String, value: Int, subtype: String? = nil) {
        self.id = UUID()
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.value = value
        self.subtype = subtype
    }
}
