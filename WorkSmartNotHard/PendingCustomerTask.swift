//
//  PendingCustomerTask.swift
//  WorkSmartNotHard
//
//  Created by Ioannis Levakos on 24/12/25.
//


import Foundation
import SwiftData


enum PendingType: String, CaseIterable, Identifiable {
    case none = "-"
    case metavitasi = "Μεταβίβαση"
    case prosfora = "Προσφορά"
    case service = "Service"
    case paraggelia = "Παραγγελία"

    var id: String { rawValue }
}

@Model
final class PendingCustomerTask {
    @Attribute(.unique) var id: UUID

    var customerName: String
    var mobilePhone: String?
    var landlinePhone: String?
    var phone: String // για συμβατότητα, μπορεί να αφαιρεθεί αργότερα
    var afm: String
    var details: String

    var categoryId: UUID?
    var categoryName: String?
    var pendingType: String? // PendingType.rawValue

    var isDone: Bool
    var createdAt: Date

    init(customerName: String, mobilePhone: String? = nil, landlinePhone: String? = nil, phone: String, afm: String, details: String, categoryId: UUID? = nil, categoryName: String? = nil, pendingType: String? = nil) {
        self.id = UUID()
        self.customerName = customerName
        self.mobilePhone = mobilePhone
        self.landlinePhone = landlinePhone
        self.phone = phone
        self.afm = afm
        self.details = details
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.pendingType = pendingType
        self.isDone = false
        self.createdAt = Date()
    }
}
