//
//  MockNetworkManager.swift
//  NalinEntainRaces
//
//  Created by Nalin Aswani on 01/04/2025.
//

import Foundation

public class MockNetworkManager: NetworkServiceProtocol {
    static let shared = NetworkManager()
    
    var isMock: Bool { true }

    func fetchRaces() async -> Races? {
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
