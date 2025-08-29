//
//  ScheduleSettlementSelectViewModel.swift
//  TravelSchedule
//
//  Created by Owi Lover on 8/17/25.
//

import SwiftUI

struct Settlement: CellItemProtocol {
    let id: UUID = UUID()
    let name: String
    let fullName: String
}

protocol CellItemProtocol: Identifiable, Sendable {
    var id: UUID { get }
    var name: String { get }
    var fullName: String { get }
}

@MainActor
@Observable final class ScheduleSettlementSelectViewModel: ScheduleSettlementSelectViewModelProtocol {
    typealias SettlementSchema = Components.Schemas.Settlement
    
    private var model: SettlementsModel
    
    private var elements: [Settlement]
    
    private(set) var settlementAndStation: Binding<SettlementAndStation>?
    
    private(set) var filteredElements: [Settlement] = []
    private(set) var pickedCity: String?

    var text: String = ""
    var isScheduleStationSelectViewPresented: Bool = false
    var isSearchBarFocused: Bool = false
    
    var isViewPresented: Binding<Bool>
    
    var isLoading: Bool = false
    
    let type: SelectionType
    
    init(isViewPresented: Binding<Bool>, type: SelectionType, settlementAndStation: Binding<SettlementAndStation>?, model: SettlementsModel = SettlementsModel.shared) {
        self.type = type
        self.isViewPresented = isViewPresented
        self.model = model
        self.elements = []
        self.settlementAndStation = settlementAndStation
        self.filteredElements = self.elements
    }
    
    func setFilteredElements(_ filteredElements: [Settlement]) {
        self.filteredElements = filteredElements
    }
    
    func returnToRootView() {
        isViewPresented.wrappedValue = false
    }
    
    func setIsViewPresented(_ isViewPresented: Bool) {
        self.isViewPresented.wrappedValue = isViewPresented
    }
    
    func updateFilteredElements() {
        filteredElements = text.isEmpty ? elements : elements.filter { $0.name.lowercased().contains(text.lowercased()) }
    }
    
    func presentScheduleStationSelectView(withPickedCity city: String?) {
        setPickedCity(city)
        presentScheduleStationSelectView()
    }
    
    private func setPickedCity(_ city: String?) {
        pickedCity = city
        
        presentScheduleStationSelectView()
    }
    
    func isEmpty() -> Bool {
        return filteredElements.isEmpty
    }
    
    private func presentScheduleStationSelectView() {
        isScheduleStationSelectViewPresented = true
    }
    
    func loadElements() async {
        isLoading = true
        self.elements = await model.getSettlementsString().compactMap { Settlement(name: $0, fullName: $0) }

        updateFilteredElements()
        isLoading = false
        print("Loaded!")
    }
    
}

@MainActor
protocol ScheduleSettlementSelectViewModelProtocol {
    var text: String { get set }
    
    var isLoading: Bool { get }
    
    var settlementAndStation: Binding<SettlementAndStation>? { get }
    
    var isScheduleStationSelectViewPresented: Bool { get set }
    
    var isSearchBarFocused: Bool { get set }
    
    var isViewPresented: Binding<Bool> { get set }
    
    var pickedCity: String? { get }
    
    func loadElements() async
    
    func isEmpty() -> Bool
    
    func updateFilteredElements()
}
