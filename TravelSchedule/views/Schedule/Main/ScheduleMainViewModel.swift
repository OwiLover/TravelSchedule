//
//  ScheduleMainViewModel.swift
//  TravelSchedule
//
//  Created by Owi Lover on 8/18/25.
//

import SwiftUI

@Observable final class SettlementAndStation {
    typealias Settlement = Components.Schemas.Settlement
    typealias Station = Components.Schemas.Station
    
    private var selectedSettlement: Settlement?
    private var selectedStation: Station?
    
    init(selectedSettlement: Settlement? = nil, selectedStation: Station? = nil) {
        self.selectedSettlement = selectedSettlement
        self.selectedStation = selectedStation
    }
    
    var selectionText: String {
        get {
            guard let cityName = selectedSettlement?.title, let stationName = selectedStation?.title else {
                return ""
            }
            let shortStationName = extractContentOrWhole(from: stationName)
            return "\(cityName) (\(shortStationName))"
        }
        set {
            return
        }
    }
    
    func checkSelection() -> Bool {
        guard let _ = selectedSettlement, let _ = selectedStation else {
            return false
        }
        return true
    }
    
    func makeSelection(settlement: Settlement, station: Station) {
        self.selectedSettlement = settlement
        self.selectedStation = station
    }
    
    func getStation() -> Station? {
        return selectedStation
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
}

@MainActor
@Observable final class ScheduleMainViewModel: ScheduleMainViewModelProtocol {
    
    private let model = SettlementsModel.shared
    
    var selectedFrom: SettlementAndStation = SettlementAndStation()
    var selectedTo: SettlementAndStation = SettlementAndStation()
    
    private(set) var storiesModel = ScheduleStoriesModel()
    
    var selectionFromText: String {
        get {
            getSelectedSettlementString(type: .from)
        }
        set { }
    }
    
    var selectionToText: String {
        get {
            getSelectedSettlementString(type: .to)
        }
        set { }
    }
    
    var isPresentedFromView: Bool = false
    var isPresentedToView: Bool = false
    var isPresentedCarrierView: Bool = false
    var isStoryPresented: Bool = false
    
    var selectedStory: Story? = nil
    
    func presentCarrierView() {
        isPresentedCarrierView = true
    }
    
    func swapSettlements() {
        let buffer = selectedFrom
        selectedFrom = selectedTo
        selectedTo = buffer
    }
    
    func checkSelection() -> Bool {
        selectedTo.checkSelection() && selectedFrom.checkSelection()
    }
    
    func getSelectedSettlementString(type: SelectionType) -> String {
        switch type {
        case .from:
            selectedFrom.selectionText
        case .to:
            selectedTo.selectionText
        }
    }
    
    func selectStory(_ story: Story) {
        story.isWatched = true
        selectedStory = story
        isStoryPresented = true
    }
}

@MainActor
protocol ScheduleMainViewModelProtocol {
    
    var storiesModel: ScheduleStoriesModel { get }
    
    var isPresentedFromView: Bool { get set }
    var isPresentedToView: Bool { get set }
    var isPresentedCarrierView: Bool { get set }
    var isStoryPresented: Bool { get set }
    
    var selectionFromText: String { get set }
    var selectionToText: String { get set }
    
    var selectedStory: Story? { get set }
    
    func presentCarrierView()
    
    func selectStory(_ story: Story)
    
    func checkSelection() -> Bool
    func swapSettlements()
    
    var selectedFrom: SettlementAndStation { get set }
    var selectedTo: SettlementAndStation { get set }
}
