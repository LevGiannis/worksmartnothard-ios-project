import Foundation

extension Date {
    var startOfMonth: Date {
        let cal = Calendar.current
        let comps = cal.dateComponents([.year, .month], from: self)
        return cal.date(from: comps) ?? self
    }

    var startOfNextMonth: Date {
        Calendar.current.date(byAdding: .month, value: 1, to: startOfMonth) ?? self
    }

    var endOfMonth: Date {
        // last moment of the month
        startOfNextMonth.addingTimeInterval(-1)
    }

    func isSameMonth(as other: Date) -> Bool {
        let cal = Calendar.current
        let a = cal.dateComponents([.year, .month], from: self)
        let b = cal.dateComponents([.year, .month], from: other)
        return a.year == b.year && a.month == b.month
    }

    var monthTitleGR: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "el_GR")
        f.dateFormat = "LLLL yyyy"
        return f.string(from: self)
    }

    /// Unique key per month, e.g. "2025-12"
    var monthKey: String {
        let cal = Calendar.current
        let c = cal.dateComponents([.year, .month], from: self)
        let y = c.year ?? 0
        let m = c.month ?? 0
        return String(format: "%04d-%02d", y, m)
    }
}
