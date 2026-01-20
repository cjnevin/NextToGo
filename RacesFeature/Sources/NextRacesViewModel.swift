//
//  NextRacesViewModel.swift
//  RacesFeature
//
//  Created by Chris Nevin on 18/5/2025.
//

import CasePaths
import Core
import Foundation
import OSLog

@MainActor
@Observable
public final class NextRacesViewModel {
    @CasePathable
    public enum State {
        case idle
        case loading
        case loaded([RaceDisplayModel])
        case error(String)
    }

    public var state: State = .idle
    public var greyhounds = true {
        didSet {
            resetIfNoneSelected()
        }
    }
    public var harnesses = true {
        didSet {
            resetIfNoneSelected()
        }
    }
    public var horses = true {
        didSet {
            resetIfNoneSelected()
        }
    }

    private let dateProvider: DateProvider
    private let endpoint: NextRacesEndpoint
    private let logger = Logger(subsystem: "com.cjnevin.nexttogo", category: "NextRacesViewModel")
    private let sleepProvider: SleepProvider

    private var latestResponse: NextRacesResponse?
    private var fetchTask: Task<Void, Never>?
    private var uiTask: Task<Void, Never>?

    public init(
        dateProvider: DateProvider = Calendar.current,
        endpoint: NextRacesEndpoint = APIManager(decoder: .default),
        sleepProvider: SleepProvider = TaskBasedSleepProvider()
    ) {
        self.dateProvider = dateProvider
        self.endpoint = endpoint
        self.sleepProvider = sleepProvider
    }

    public func startFetching() async {
        fetchTask?.cancel()
        fetchTask = Task { [weak self] in
            guard let self else { return }
            while await sleepProvider.canSleep() {
                await fetchRaces()
                try? await sleepProvider.sleep(for: .seconds(10))
            }
            logger.debug("Fetching cancelled")
        }
        await fetchTask?.value
    }

    public func startTimer() async {
        uiTask?.cancel()
        uiTask = Task { [weak self] in
            guard let self else { return }
            while await sleepProvider.canSleep() {
                updateUI()
                try? await sleepProvider.sleep(for: .milliseconds(250))
            }
            logger.debug("UI updates cancelled")
        }
        await uiTask?.value
    }

    private func allowedCategories() -> [Category] {
        [
            greyhounds ? .greyhoundRacing : nil,
            harnesses ? .harnessRacing : nil,
            horses ? .horseRacing : nil
        ].compactMap { $0 }
    }

    private func resetIfNoneSelected() {
        // This copies the behaviour of the website, when you untick all.
        if !greyhounds, !harnesses, !horses {
            greyhounds = true
            harnesses = true
            horses = true
        }
    }

    private func updateUI() {
        guard let latestResponse else {
            return
        }
        let models = latestResponse.toDisplayModels(
            allowedCategories: allowedCategories(),
            dateProvider: dateProvider
        )
        state = .loaded(models)
    }

    private func fetchRaces() async {
        do {
            logger.debug("Fetching")
            if latestResponse == nil {
                state = .loading
            }
            latestResponse = try await endpoint.fetchNextRaces()
            logger.debug("Fetched")
            updateUI()
        } catch {
            logger.debug("Fetching failed \(error.localizedDescription)")
            switch error {
            case .noInternet: state = .error("Unable to retrieve races. Please check your internet connection.")
            default: state = .error("Unable to retrieve races. Please try again later.")
            }
            latestResponse = nil
        }
    }
}
