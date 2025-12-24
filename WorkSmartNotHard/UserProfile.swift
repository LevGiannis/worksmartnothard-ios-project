//
//  Untitled.swift
//  WorkSmartNotHard
//
//  Created by Ioannis Levakos on 24/12/25.
//

import Foundation
import SwiftData

@Model
final class UserProfile {
    @Attribute(.unique) var id: UUID

    var firstName: String
    var lastName: String
    var email: String
    var nickname: String
    var storeCode: String

    var createdAt: Date

    init(firstName: String, lastName: String, email: String, nickname: String, storeCode: String) {
        self.id = UUID()
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.nickname = nickname
        self.storeCode = storeCode
        self.createdAt = Date()
    }
}
