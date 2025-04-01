//
//  MockNetworkManager.swift
//  NalinEntainRaces
//
//  Created by Nalin Aswani on 01/04/2025.
//

import Foundation

/// A MockNetworkManager that is used in previews and tests.
public class MockNetworkManager: NetworkServiceProtocol {
    /// A singleton MockNetworkManager that can be injected in a class. Is brought in using dependency injection for the RacesViewModel but only for tests and Previews
    static let shared = NetworkManager()
    
    /// Fetches a locally stored json file and returns the Races object from that response stored in that file.
    /// - Returns: Returns the Races object
    func fetchRaces() async -> Races? {
        // Here also rather than throwing an error and crashing the app I am printing errors.
        do {
            return try fetchLocalData(fileName: "mockRaces")
        } catch {
            print("Error parsing local races:", error)
            return nil
        }
    }
    
    // Method for fetching data from a local JSON file
    private func fetchLocalData<T: Decodable>(fileName: String) throws -> T {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw NSError(domain: "Invalid file name", code: 0, userInfo: nil)
        }
        
        let data = try Data(contentsOf: url)
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }
}
