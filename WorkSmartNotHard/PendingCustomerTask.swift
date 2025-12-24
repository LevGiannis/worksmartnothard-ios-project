//
//  PendingCustomerTask.swift
//  WorkSmartNotHard
//
//  Created by Ioannis Levakos on 24/12/25.
//

import Foundation
import SwiftData

@Model
final class PendingCustomerTask {
    @Attribute(.unique) var id: UUID

    var customerName: String
    var phone: String
    var afm: String
    var details: String

    var isDone: Bool
    var createdAt: Date

    init(customerName: String, phone: String, afm: String, details: String) {
        self.id = UUID()
        self.customerName = customerName
        self.phone = phone
        self.afm = afm
        self.details = details
        self.isDone = false
        self.createdAt = Date()
    }
}
