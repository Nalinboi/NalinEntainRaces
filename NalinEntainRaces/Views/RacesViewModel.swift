//
//  RacesViewModel.swift
//  NalinEntainRaces
//
//  Created by Nalin Aswani on 30/03/2025.
//

import SwiftUI

class RacesViewModel: ObservableObject {
    @Published var races: Races?
    @Published var selectedCategory: RaceCategory? // Category filter
    @Published var fetchedRaces: [RaceSummary] = []  // Fetched races that we use to update sortedRaces
    let filterOptions = ["All", "Horse", "Harness", "Greyhound"]
    
    public init() {
        Task {
            await fetchRaces() // Asynchoronously make the get request from the api
        }
    }
    
    func timeUntil(timestamp: TimeInterval) -> String? {
        let now = Date().timeIntervalSince1970
        let remainingTime = max(timestamp - now, 0) // Calculate time left

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        
        return formatter.string(from: remainingTime) // Format remaining time
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
    
    // Method to fetch races from API
    @MainActor func fetchRaces() async {
        let urlString = "https://api.neds.com.au/rest/v1/racing/?method=nextraces&count=10"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            self.races = try JSONDecoder().decode(Races.self, from: data)
            self.fetchedRaces = self.sortedRaces // After fetching, update the fetchedRaces property
        } catch {
            print("Error fetching races:", error)
        }
    }
}
