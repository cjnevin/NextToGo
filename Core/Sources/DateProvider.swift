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
        let components = dateComponents(
            [.minute, .second],
            from: Date(),
            to: date
        )
        let minutes = components.minute ?? 0
        let seconds = abs(components.second ?? 0)
        if abs(minutes) == 0 {
            return "\(components.second ?? 0)s"
        } else {
            return "\(components.minute ?? 0)m \(seconds)s"
        }
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
