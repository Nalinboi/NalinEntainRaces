//
//  NalinEntainRacesTests.swift
//  NalinEntainRacesTests
//
//  Created by Nalin Aswani on 30/03/2025.
//

import Testing
import SwiftUI
@testable import NalinEntainRaces

@MainActor struct NalinEntainRacesTests {

    @Test func testFormattedTimeTill() async throws {
        let viewModel = RacesViewModel(networkManager: MockNetworkManager.shared)
        
        // Race that hasn't started yet
        let futureTimestamp = Date().timeIntervalSince1970 + 120
        let countdown = viewModel.formattedTimeTill(timestamp: futureTimestamp)
        #expect(countdown?.contains("2m") == true, "Countdown should show 2 minutes remaining")

        // Race has started
        let pastTimestamp = Date().timeIntervalSince1970 - 30
        let expiredCountdown = viewModel.formattedTimeTill(timestamp: pastTimestamp)
        #expect(expiredCountdown?.contains("-30s") == true, "Countdown should show 30 seconds have past")
    }

    @Test func testHasStarted() async throws {
        let viewModel = RacesViewModel(networkManager: MockNetworkManager.shared)

        let pastTimestamp = Date().timeIntervalSince1970 - 10
        let futureTimestamp = Date().timeIntervalSince1970 + 10

        #expect(viewModel.hasStarted(timestamp: pastTimestamp) == true, "Race should have started")
        #expect(viewModel.hasStarted(timestamp: futureTimestamp) == false, "Race should not have started yet")
    }

    @Test func testShouldDisplay() async throws {
        let viewModel = RacesViewModel(networkManager: MockNetworkManager.shared)

        let now = Date().timeIntervalSince1970
        let recentRaceTimestamp = now - 30  // 30 seconds ago
        let oldRaceTimestamp = now - 70     // 70 seconds ago (past 1 min)

        #expect(viewModel.shouldDisplay(timestamp: recentRaceTimestamp) == true, "Race within 1 minute should be displayed")
        #expect(viewModel.shouldDisplay(timestamp: oldRaceTimestamp) == false, "Race older than 1 minute should not be displayed")
    }

    @Test func testFilteredRacesByCategory() async throws {
        let viewModel = RacesViewModel(networkManager: MockNetworkManager.shared)
        viewModel.selectedCategory = .harness
        let filteredRaces = viewModel.sortedRaces
        #expect(filteredRaces.allSatisfy { $0.category == .harness }, "All races should be of selected category")
    }
}
