//
//  RacesViewModel.swift
//  NalinEntainRaces
//
//  Created by Nalin Aswani on 30/03/2025.
//

import SwiftUI

@MainActor class RacesViewModel: ObservableObject {
    @Published var races: Races?
    @Published var selectedCategory: RaceCategory? // Category filter
    @Published var fetchedRaces: [RaceSummary] = []  // Fetched races that we use to update sortedRaces
    let filterOptions = ["All", "Horse", "Harness", "Greyhound"]
    
    // TODO: There is a Swift6 warning here that I can't get rid of
    // Unsure why, the singleton should be a Main Actor, and this should be called from an isolated context (marked with @MainActor
    public init(networkManager: NetworkServiceProtocol = NetworkManager.shared) {
        Task {
            self.races = await networkManager.fetchRaces() // Asynchoronously make the get request from the api
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
                // Filter by selected category if any
                selectedCategory == nil || race.category == selectedCategory
            }
            .prefix(5) // Only take the first 5 races
            .map { $0 }
    }
    
    func timeUntil(timestamp: TimeInterval) -> String? {
        let now = Date().timeIntervalSince1970
        let remainingTime = timestamp - now // Calculate time left

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        
        return formatter.string(from: remainingTime) // Format remaining time
    }
}
