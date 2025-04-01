//
//  NalinEntainRacesApp.swift
//  NalinEntainRaces
//
//  Created by Nalin Aswani on 30/03/2025.
//

import SwiftUI

@main
struct NalinEntainRacesApp: App {

    var body: some Scene {
        WindowGroup {
            // Use mock network manager in UI Tests if that launch argument exists
            if ProcessInfo.processInfo.arguments.contains("-UITestMode") {
                RacesView(viewModel: RacesViewModel(networkManager: MockNetworkManager.shared))
            } else {
                RacesView(viewModel: RacesViewModel(networkManager: NetworkManager.shared))
            }
        }
    }
}
