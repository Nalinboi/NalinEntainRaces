//
//  NetworkManager.swift
//  NalinEntainRaces
//
//  Created by Nalin Aswani on 01/04/2025.
//

import SwiftUI

protocol NetworkServiceProtocol {
    func fetchRaces() async -> Races?
}

class NetworkManager: NetworkServiceProtocol {
    /// A singleton NetworkManager that can be injected in a class. Is brought in using dependency injection for the RacesViewModel
    static let shared = NetworkManager()
    
    /// Fetches races using the api link that was given
    /// - Returns: Returns the json response of the get request in an object called Races.
    func fetchRaces() async -> Races? {
        let urlString = "https://api.neds.com.au/rest/v1/racing/?method=nextraces&count=10"
        
        // Rather than failing and crashing the app completely, I am just printing out errors.
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return nil
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let races = try JSONDecoder().decode(Races.self, from: data)
            return races
        } catch {
            print("Error fetching races:", error)
            return nil
        }
    }
}
