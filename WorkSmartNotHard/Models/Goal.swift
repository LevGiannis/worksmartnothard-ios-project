//
//  Goal.swift
//  WorkSmartNotHard
//
//  Created by Ioannis Levakos on 24/12/25.
//

import Foundation
import SwiftData

@Model
final class Goal {
    @Attribute(.unique) var id: UUID
    var categoryId: UUID
    var categoryName: String
    var target: Int
    var createdAt: Date

    init(categoryId: UUID, categoryName: String, target: Int) {
        self.id = UUID()
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.target = target
        self.createdAt = Date()
    }
}
