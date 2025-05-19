//
//  SleepProvider.swift
//  Core
//
//  Created by Chris Nevin on 18/5/2025.
//

import Foundation

public protocol SleepProvider: Actor {
    func canSleep() -> Bool
    func sleep(for duration: Duration) async throws
}

public actor TaskBasedSleepProvider: SleepProvider {
    public func canSleep() -> Bool {
        !Task.isCancelled
    }

    public func sleep(for duration: Duration) async throws {
        try await Task.sleep(for: duration)
    }

    public init() {}
}

#if DEBUG
public actor MockSleepProvider: SleepProvider {
    private var durations: [Duration] = []
    private var sleptOnce = false

    public init() {}

    public func canSleep() -> Bool {
        !sleptOnce
    }

    public func getDurations() -> [Duration] {
        durations
    }

    public func sleep(for duration: Duration) async throws {
        durations.append(duration)
        sleptOnce = true
    }
}
#endif
