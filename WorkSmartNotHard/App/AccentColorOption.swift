import SwiftUI

enum AccentColorOption: String, CaseIterable, Identifiable {
    case blue
    case pink
    case purple
    case gray
    case green
    case navy

    var id: String { rawValue }

    var titleGR: String {
        switch self {
        case .blue: return "Μπλε"
        case .pink: return "Ροζ"
        case .purple: return "Μωβ"
        case .gray: return "Γκρι"
        case .green: return "Πράσινο"
        case .navy: return "Σκούρο μπλε"
        }
    }

    var color: Color {
        switch self {
        case .blue: return .blue
        case .pink: return Color(red: 1.0, green: 0.2, blue: 0.6) // πιο έντονο ροζ
        case .purple: return .purple
        case .gray: return .gray
        case .green: return .green
        case .navy: return Color(red: 0.1, green: 0.2, blue: 0.5)
        }
    }
}
