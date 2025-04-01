//
//  NalinEntainRacesTests.swift
//  NalinEntainRacesTests
//
//  Created by Nalin Aswani on 30/03/2025.
//

import Testing
import SwiftUI
@testable import NalinEntainRaces

struct NalinEntainRacesTests {
    @MainActor struct RacesViewModelTests {
        /// A viewModel that all the tests below can reference
        let viewModel = RacesViewModel(networkManager: MockNetworkManager.shared)
        
        /// Testing the formattedTimeTill function in  RacesViewModel
        @Test func testFormattedTimeTill() async throws {
            // Race that hasn't started yet
            let futureTimestamp = Date().timeIntervalSince1970 + 120
            let countdown = viewModel.formattedTimeTill(timestamp: futureTimestamp)
            #expect(countdown?.contains("2m") == true, "Countdown should show 2 minutes remaining")
            
            // Race has started
            let pastTimestamp = Date().timeIntervalSince1970 - 30
            let expiredCountdown = viewModel.formattedTimeTill(timestamp: pastTimestamp)
            #expect(expiredCountdown?.contains("-30s") == true, "Countdown should show 30 seconds have past")
        }
        
        /// Testing the hasStarted function in  RacesViewModel
        @Test func testHasStarted() async throws {
            let pastTimestamp = Date().timeIntervalSince1970 - 10
            let futureTimestamp = Date().timeIntervalSince1970 + 10
            
            #expect(viewModel.hasStarted(timestamp: pastTimestamp) == true, "Race should have started")
            #expect(viewModel.hasStarted(timestamp: futureTimestamp) == false, "Race should not have started yet")
        }
        
        /// Testing the shouldDisplay function in  RacesViewModel
        @Test func testShouldDisplay() async throws {
            let now = Date().timeIntervalSince1970
            let recentRaceTimestamp = now - 30  // 30 seconds ago
            let oldRaceTimestamp = now - 70     // 70 seconds ago (past 1 min)
            
            #expect(viewModel.shouldDisplay(timestamp: recentRaceTimestamp) == true, "Race within 1 minute should be displayed")
            #expect(viewModel.shouldDisplay(timestamp: oldRaceTimestamp) == false, "Race older than 1 minute should not be displayed")
        }
        
        /// Testing the filtered races after choosing a category in  RacesViewModel
        @Test func testFilteredRacesByCategory() async throws {
            viewModel.selectedCategory = .harness
            let filteredRaces = viewModel.sortedRaces
            #expect(filteredRaces.allSatisfy { $0.category == .harness }, "All races should be of selected category")
        }
    }
}
