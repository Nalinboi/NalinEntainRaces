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
            .navigationTitle("Upcoming Races")
        }
    }
    
    @ViewBuilder
    var filterButton: some View {
        Section {
            Picker("Race Category", selection: $viewModel.selectedCategory) {
                ForEach(viewModel.filterOptions, id: \.self) { category in
                    Text(category).tag(category)
                }
            }
        }
    }
    
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
    
    @ViewBuilder
    func raceInformation(race: RaceSummary) -> some View {
        if let advertisedStart = race.advertisedStart?.seconds,
           let countdown = viewModel.countdowns[race.id] {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    if let meetingName = race.meetingName {
                        Text(meetingName)
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
    RacesView(viewModel: RacesViewModel())
}
