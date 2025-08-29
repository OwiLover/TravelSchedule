//
//  CarrierSelectViewModel.swift
//  TravelSchedule
//
//  Created by Owi Lover on 8/19/25.
//

import SwiftUI

@Observable final class CarrierFilters {
    var selectedTimeFilters: Set<FilterOption> = []
    var allowTransitionFilter: Bool = true
    
    func isFilteringActive() -> Bool {
        return !selectedTimeFilters.isEmpty || !allowTransitionFilter
    }
}

@MainActor
@Observable final class CarrierSelectViewModel: CarrierSelectViewModelProtocol {
    
    typealias Carriers = Components.Schemas.Carrier
    
    private var settlementFrom: SettlementAndStation
    private var settlementTo: SettlementAndStation
    private var selectedCarrier: CarriersCard?
    private var model: CarriersScheduleModelProtocol
    
    private(set) var isLoading: Bool = false
    
    init(settlementFrom: SettlementAndStation, settlementTo: SettlementAndStation, model: CarriersScheduleModelProtocol = CarriersScheduleModel()) {
        self.model = model
        self.settlementFrom = settlementFrom
        self.settlementTo = settlementTo
        
        self.elements = []
        self.filteredElements = elements
    }
    
    var carrierFilters: CarrierFilters = CarrierFilters()
    var elements: [CarrierInfo]
    
    var isCarriersFilterSelectViewPresented: Bool = false
    var isCarriersCardViewPresented: Bool = false
    
    private(set) var filteredElements: [CarrierInfo] = []
    
    var isFilteringActive: Bool {
        carrierFilters.isFilteringActive()
    }
    
    private func getSettlementFrom() -> String {
        settlementFrom.selectionText
    }
    
    private func getSettlementTo() -> String {
        settlementTo.selectionText
    }
    
    func getCarriersRouteString() -> String {
        "\(getSettlementFrom()) → \(getSettlementTo())"
    }
    
    func selectCarrier(_ carrier: CarriersCard) {
        selectedCarrier = carrier
        isCarriersCardViewPresented = true
    }
    
    func presentCarriersFilterSelectView() {
        isCarriersFilterSelectViewPresented = true
    }
    
    func getSelectedCarrier() -> CarriersCard? {
        selectedCarrier
    }
    
    func updateFilteredElements() {
        guard carrierFilters.isFilteringActive() else {
            filteredElements = elements
            return
        }
        
        filteredElements = elements.filter { element in
            if !carrierFilters.allowTransitionFilter {
                if !element.importantInfo.isEmpty {
                    return false
                }
            }
    
            var isIncluded: Bool = carrierFilters.selectedTimeFilters.isEmpty ? true : false
            
            carrierFilters.selectedTimeFilters.forEach { filter in
                filter.isIncluded(time: element.timeStart) ? isIncluded = true : ()
            }
            
            return isIncluded
        }
    }
    
    func loadData() async {
        isLoading = true
        guard let stationFrom = settlementFrom.getStation(), let stationTo = settlementTo.getStation() else {
            return
        }
        
        let result = await model.getCarrierInfos(stationFrom: stationFrom, stationTo: stationTo)
        
        elements = result
        updateFilteredElements()
        
        isLoading = false
    }
}

@MainActor
protocol CarrierSelectViewModelProtocol {
    var isFilteringActive: Bool { get }
    var isCarriersFilterSelectViewPresented: Bool { get set }
    var isCarriersCardViewPresented: Bool { get set }
    var filteredElements: [CarrierInfo] { get }
    var carrierFilters: CarrierFilters { get set }
    var isLoading: Bool { get }
    
    func getCarriersRouteString() -> String
    func selectCarrier(_ carrier: CarriersCard)
    func presentCarriersFilterSelectView()
    func getSelectedCarrier() -> CarriersCard?
    func loadData() async
}
