//
//  ScheduleStationSelectView.swift
//  TravelSchedule
//
//  Created by Owi Lover on 8/18/25.
//

import SwiftUI

struct Station: CellItemProtocol {
    let id: UUID = UUID()
    let name: String
    let fullName: String
}

@MainActor
@Observable final class ScheduleStationSelectViewModel: ScheduleStationSelectViewModelProtocol {
    
    private var model: SettlementsModel
    
    private var settlementAndStation: Binding<SettlementAndStation>?
    
    private var isViewStackPresented: Binding<Bool>
    
    var text: String = ""
    var isSearchBarFocused: Bool = false
    
    private let pickedSettlement: String
    
    private var elements: [Station]
    
    private(set) var filteredElements: [Station] = []
    
    let type: SelectionType
    
    init(isViewStackPresented: Binding<Bool>, pickedSettlement: String, type: SelectionType, settlementAndStation: Binding<SettlementAndStation>?, model: SettlementsModel = SettlementsModel.shared) {
        self.model = model
        self.type = type
        self.isViewStackPresented = isViewStackPresented
        self.pickedSettlement = pickedSettlement
        self.elements = []
        self.settlementAndStation = settlementAndStation
        self.filteredElements = elements
    }
    
    func makeSelectionAndReturnToRootView(pickedStation: String) async {
        await makeSelection(pickedStation: pickedStation)
        returnToRootView()
    }
    
    func updateFilteredElements() {
        filteredElements = text.isEmpty ? elements : elements.filter { $0.name.lowercased().contains(text.lowercased()) }
    }
    
    func loadElements() async {
        elements = await model.getSettlementStations(settlementName: pickedSettlement).compactMap { station in
            guard let title = station.title else { return nil }
            let short_title = extractContentOrWhole(from: title)
            return Station(name: short_title, fullName: title)
        }
        updateFilteredElements()
    }
    
    private func extractContentOrWhole(from input: String) -> String {
        guard let openIndex = input.firstIndex(of: "("),
              let closeIndex = input.firstIndex(of: ")"),
              openIndex < closeIndex else {
            return input
        }
        let start = input.index(after: openIndex)
        let content = String(input[start..<closeIndex])
        return content
    }
    
    private func returnToRootView() {
        isViewStackPresented.wrappedValue = false
    }
    
    
    private func makeSelection(pickedStation: String) async {
        guard let result = await model.getSettlementAndStation(settlementName: pickedSettlement, stationName: pickedStation) else { return }
        settlementAndStation?.wrappedValue.makeSelection(settlement: result.settlement, station: result.station)
    }
}

@MainActor
protocol ScheduleStationSelectViewModelProtocol {
    var filteredElements: [Station] { get }
    var text: String { get set }
    var isSearchBarFocused: Bool { get set }
    func updateFilteredElements()

    func makeSelectionAndReturnToRootView(pickedStation: String) async
    
    func loadElements() async
}
