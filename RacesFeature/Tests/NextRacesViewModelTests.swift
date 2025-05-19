//
//  NextRacesViewModelTests.swift
//  RacesFeature
//
//  Created by Chris Nevin on 19/5/2025.
//

import Core
@testable import RacesFeature
import Testing

@MainActor
@Suite
struct NextRacesViewModelTests {
    @Test
    func viewModelStartsInIdleState() {
        // GIVEN
        let dateProvider = MockDateProvider()
        let endpoint = MockNextRacesEndpoint()
        let sleepProvider = MockSleepProvider()
        // WHEN
        let viewModel = NextRacesViewModel.init(
            dateProvider: dateProvider,
            endpoint: endpoint,
            sleepProvider: sleepProvider
        )
        // THEN
        let idleState: Void? = viewModel.state[case: \.idle]
        #expect(idleState.unsafelyUnwrapped == ())
    }

    @Test
    func viewModelTransitionsToLoadedStateOnFetch() async {
        // GIVEN
        let dateProvider = MockDateProvider()
        let endpoint = MockNextRacesEndpoint()
        let sleepProvider = MockSleepProvider()
        // WHEN
        let viewModel = NextRacesViewModel.init(
            dateProvider: dateProvider,
            endpoint: endpoint,
            sleepProvider: sleepProvider
        )
        await viewModel.startFetching()
        // THEN
        let loadedState: [RaceDisplayModel]? = viewModel.state[case: \.loaded]
        let durations = await sleepProvider.getDurations()
        #expect(durations == [.seconds(10)])
        #expect(loadedState.unsafelyUnwrapped.count > 0)
    }

    @Test
    func viewModelTransitionsToErrorStateOnFetch() async {
        // GIVEN
        let dateProvider = MockDateProvider()
        let endpoint = MockNextRacesEndpoint(success: false)
        let sleepProvider = MockSleepProvider()
        // WHEN
        let viewModel = NextRacesViewModel.init(
            dateProvider: dateProvider,
            endpoint: endpoint,
            sleepProvider: sleepProvider
        )
        await viewModel.startFetching()
        // THEN
        let errorState: String? = viewModel.state[case: \.error]
        #expect(errorState != nil)
    }
}
