//
//  AppCategory.swift
//  WorkSmartNotHard
//
//  Created by Ioannis Levakos on 24/12/25.
//

import Foundation
import SwiftData

@Model
final class AppCategory {
    @Attribute(.unique) var id: UUID
    var name: String
    var isActive: Bool
    var sortOrder: Int
    var createdAt: Date

    init(name: String, isActive: Bool = true, sortOrder: Int) {
        self.id = UUID()
        self.name = name
        self.isActive = isActive
        self.sortOrder = sortOrder
        self.createdAt = Date()
    }
}
