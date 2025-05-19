//
//  ElapsedTimeProviderTests.swift
//  Core
//
//  Created by Chris Nevin on 18/5/2025.
//

@testable import Core
import Foundation
import Testing

@Suite("DateProvider tests")
struct DateProviderTests {
    let calendar = Calendar.current

    @Test
    func currentDate() {
        // GIVEN
        let date = calendar.currentDate()
        // WHEN
        let now = Date()
        // THEN
        #expect(date.timeIntervalSince(now) < 1.0) // Swift Testing doesn't support accuracy so we need to compare with some tolerance
    }

    @Test("elapsedTime for same time (0 seconds)")
    func elapsedTimeZeroSeconds() {
        // GIVEN
        let date = calendar.currentDate()
        // WHEN
        let result = calendar.elapsedTime(from: date)
        // THEN
        #expect(result == "0s")
    }

    @Test("elapsedTime for 30 seconds in the future")
    func elapsedTimeSecondsFuture() {
        // GIVEN
        let date = calendar.currentDate().addingTimeInterval(31)
        // WHEN
        let result = calendar.elapsedTime(from: date)
        // THEN
        #expect(result == "30s")
    }

    @Test("elapsedTime for 30 seconds in the past")
    func elapsedTimeSecondsPast() {
        // GIVEN
        let date = calendar.currentDate().addingTimeInterval(-30)
        // WHEN
        let result = calendar.elapsedTime(from: date)
        // THEN
        #expect(result == "-30s")
    }

    @Test("elapsedTime for 1 minute and 15 seconds in the future")
    func elapsedTimeMinutesAndSecondsFuture() {
        // GIVEN
        let date = calendar.currentDate().addingTimeInterval(76)
        // WHEN
        let result = calendar.elapsedTime(from: date)
        // THEN
        #expect(result == "1m 15s")
    }

    @Test("elapsedTime for 1 minute and 15 seconds in the past")
    func elapsedTimeMinutesAndSecondsPast() {
        // GIVEN
        let date = calendar.currentDate().addingTimeInterval(-75)
        // WHEN
        let result = calendar.elapsedTime(from: date)
        // THEN
        #expect(result == "-1m 15s")
    }
}
