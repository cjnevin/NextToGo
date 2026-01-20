//
//  DateProvider.swift
//  Core
//
//  Created by Chris Nevin on 18/5/2025.
//

import Foundation

/// Provides helper methods over `Date` that enhance testability.
public protocol DateProvider {
    /// Returns the current `Date`.
    func currentDate() -> Date
    /// Returns a formatted string for a given `Date` in relation to the `currentDate`.
    func elapsedTime(from date: Date) -> String
}

extension Calendar: DateProvider {
    public func currentDate() -> Date {
        Date()
    }

    public func elapsedTime(from date: Date) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = [.dropAll]
        return formatter.string(from: Date(), to: date) ?? "0s"
    }
}

#if DEBUG
public final class MockDateProvider: DateProvider {
    public var elapsedTimeValue: String

    public init(elapsedTimeValue: String = "15s") {
        self.elapsedTimeValue = elapsedTimeValue
    }

    public func currentDate() -> Date {
        Date(timeIntervalSince1970: 0)
    }

    public func elapsedTime(from date: Date) -> String {
        elapsedTimeValue
    }
}
#endif
