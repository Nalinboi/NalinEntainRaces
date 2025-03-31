//
//  ContentView.swift
//  NalinEntainRaces
//
//  Created by Nalin Aswani on 30/03/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        RacesView(viewModel: RacesViewModel())
    }
}

#Preview {
    ContentView()
}
