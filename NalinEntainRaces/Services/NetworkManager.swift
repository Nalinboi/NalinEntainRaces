//
//  NetworkManager.swift
//  NalinEntainRaces
//
//  Created by Nalin Aswani on 01/04/2025.
//

import SwiftUI

protocol NetworkServiceProtocol {
    var isMock: Bool { get }
    func fetchRaces() async -> Races?
}

class NetworkManager: NetworkServiceProtocol {
    static let shared = NetworkManager()

    func fetchRaces() async -> Races? {
        let urlString = "https://api.neds.com.au/rest/v1/racing/?method=nextraces&count=10"
        
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
    
    var isMock: Bool { false }
}
