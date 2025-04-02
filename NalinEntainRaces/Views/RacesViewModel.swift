//
//  RacesViewModel.swift
//  NalinEntainRaces
//
//  Created by Nalin Aswani on 30/03/2025.
//

import SwiftUI

class RacesViewModel: ObservableObject {
    /// The object returned from the json response of the api given.
    @Published var races: Races?
    
    /// The selected category filter for the picker. If nil, will display all types of races.
    @Published var selectedCategory: RaceCategory?
    
    /// A list of dictionaries with the key being the id of the race and the value being the time remaining for the countdown.
    @Published var countdowns: [String: String] = [:]
    
    let networkManager: NetworkServiceProtocol
    
    private var isRunning = false
    
    /// The initialiser for the view model. Takes in a network manager which can be real or a mock.
    /// - Parameter networkManager: Can be read (NetworkManager) unless otherwise specificed (MockNetworkManager for previews and tests)
    @MainActor public init(networkManager: NetworkServiceProtocol = NetworkManager.shared) {
         self.networkManager = networkManager
        Task {
            await refreshRaces()
            await startTimer()
        }
    }
    
    /// Asynchoronously make the get request from the api to fetch the races
    /// @MainActor ensures UI updates happen on the main thread.
    /// However, the Task closure nesures the api fetch is happening asynchronously on the background thread.
    @MainActor func refreshRaces() async {
        Task {
            self.races = await networkManager.fetchRaces() // UI update on main thread
        }
    }
    
    private var timer: Timer?
    
    /// Will be updating all the countdowns every second. Needs to be main actor as this is being updated every second.
    @MainActor func startTimer() async {
        Task {
            var counter = 0
            isRunning = true
            while isRunning {
                for race in self.sortedRaces {
                    if let advertisedStart = race.advertisedStart?.seconds {
                        self.countdowns[race.id] = self.formattedTimeTill(timestamp: advertisedStart)
                    }
                }
                // Wait for 1 second before updating again
                try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
                counter += 1
                if counter == 60 {
                    // Automatically fetch the api every minute
                    await refreshRaces()
                    counter = 0
                }
            }
        }
    }
    
    // Computed property to return sorted races
    var sortedRaces: [RaceSummary] {
        guard let nextToGoIds = races?.data?.nextToGoIDS,
              let raceSummaries = races?.data?.raceSummaries else {
            return []
        }
        return nextToGoIds
            .compactMap { raceSummaries[$0] }
            .filter { race in
                guard let advertisedTime = race.advertisedStart?.seconds else {
                    return false
                }
                let isCorrectCategory = selectedCategory == nil || race.category == selectedCategory
                let shouldDisplay = shouldDisplay(timestamp: advertisedTime)
                return isCorrectCategory && shouldDisplay
            }
            .prefix(5) // Only take the first 5 races
            .map { $0 }
    }
    
    /// Returns a nice formatted string for a timer from now until the timestamp
    /// - Parameter timestamp: The timestamp in seconds that will be counted down towards
    /// - Returns: A formatted string for the remaining time left till the timestamp
    func formattedTimeTill(timestamp: TimeInterval) -> String? {
        let now = Date().timeIntervalSince1970
        let remainingTime = timestamp - now // Calculate time left
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        
        return formatter.string(from: remainingTime) // Format remaining time
    }
    
    /// Races should only display if it hasn't been longer than a minute since the race has started.
    /// - Parameter timestamp: The time the race should have started
    /// - Returns: Bool depending on if a race should be displayed or not.
    func shouldDisplay(timestamp: TimeInterval) -> Bool {
        let now = Date().timeIntervalSince1970
        let minute = 60.0
        return now < timestamp + minute
    }
    
    /// A method that checks if the race has started yet. Is espectially useful for the view where the countdown will be green if it hasn't started yet, or red if it has.
    /// - Parameter timestamp: The time the race should start
    /// - Returns: Bool depending on if a race has started or not.
    func hasStarted(timestamp: TimeInterval) -> Bool {
        let now = Date().timeIntervalSince1970
        return now > timestamp
    }
}
