//
//  RacesView.swift
//  NalinEntainRaces
//
//  Created by Nalin Aswani on 30/03/2025.
//

import SwiftUI

struct RacesView: View {
    @ObservedObject var viewModel: RacesViewModel
    
    public init(viewModel: RacesViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            Form {
                filterButton
                raceList
            }
            .refreshable {
                // The screen is able to be refreshed manually be the user.
                Task {
                    await viewModel.refreshRaces()
                }
            }
            .navigationTitle("Upcoming Races") // The title
        }
    }
    
    /// The picker at the top of the screen.
    @ViewBuilder
    var filterButton: some View {
        Section {
            Picker("Race Category", selection: $viewModel.selectedCategory) {
                ForEach(RaceCategory.allCases, id: \.self) { category in
                    if category != .unknown {
                        Text(category.shortName).tag(category)
                    }
                }
                Text("All").tag(nil as RaceCategory?)
            }
        }
    }
    
    /// A list of race information cells.
    @ViewBuilder
    var raceList: some View {
        if !viewModel.sortedRaces.isEmpty {
            List {
                ForEach(viewModel.sortedRaces) { race in
                    raceInformation(race: race)
                }
            }
        }
    }
    
    /// Race information includes the Race name, number, race type and countdown
    /// - Parameter race: The race summary with all the info needed for what to display here
    /// - Returns: The race information calls in the list.
    @ViewBuilder
    func raceInformation(race: RaceSummary) -> some View {
        if let advertisedStart = race.advertisedStart?.seconds,
           let countdown = viewModel.countdowns[race.id] {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    if let meetingName = race.meetingName {
                        Text(meetingName)
                            .font(.title3)
                            .bold()
                        if let raceNumber = race.raceNumber {
                            Text("Race number: \(raceNumber)")
                        }
                        if let raceType = race.category?.shortName {
                            Text("Race type: \(raceType)")
                        }
                    }
                }
                Spacer()
                Text(countdown)
                    .foregroundStyle(viewModel.hasStarted(timestamp: advertisedStart) ? .red : .green)
            }
        }
    }
    
    
}

#Preview {
    // Using mock network manager for the preview so we aren't always calling the api.
    RacesView(viewModel: RacesViewModel(networkManager: MockNetworkManager.shared))
}
