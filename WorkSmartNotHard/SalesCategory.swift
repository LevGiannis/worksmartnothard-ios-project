//
//  SalesCategory.swift
//  WorkSmartNotHard
//
//  Created by Ioannis Levakos on 24/12/25.
//

import Foundation

enum SalesCategory: String, CaseIterable, Identifiable {
    case portinMobile = "PortIN mobile"
    case exprepayPre2ec = "Exprepay"
    case fwa = "FWA"
    case vodafoneHomeWF = "Vodafone Home W/F"
    case migrationFTTH = "Migration FTTH"
    case post2post = "Post2post"
    case ec2post = "Ec2post"
    case first = "First"
    case newConnection = "New Connection"
    case appointments = "Ραντεβού"
    case devices = "Συσκευές"
    case tv = "TV"
    case migrationVDSL = "Migration VDSL"

    var id: String { rawValue }
}

enum VodafoneHomeWFSubtype: String, CaseIterable, Identifiable {
    case adsl = "ADSL"
    case tripleAdsl = "TRIPLE ADSL"
    case vdsl = "VDSL"
    case tripleVdsl = "TRIPLE VDSL"
    case ftthDouble = "FTTH DOUBLE"
    case ftthTriple = "FTTH TRIPLE"
    case fwa = "FWA"
    case fwaVoice = "FWA VOICE"

    var id: String { rawValue }
}
