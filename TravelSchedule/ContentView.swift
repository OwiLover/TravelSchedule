//
//  ContentView.swift
//  TravelSchedule
//
//  Created by Owi Lover on 6/27/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView().onAppear {
//        testFetchScheduleSegment()
//        testFetchSchedule()
//        testFetchThreadStations()
//        testFetchNearestStations()
//        testFetchNearestCity()
//        testFetchCarriers()
//        testFetchStationsList()
        testFetchCopyright()
    }
}
