//
//  ScheduleMainModel.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/24/25.
//

import SwiftUI

enum SelectionType {
    case from
    case to
}

@Observable final class ScheduleSettlementPickerModel: ScheduleSettlementSelectModelProtocol, ScheduleStationSelectModelProtocol, Sendable {
    
//    MARK: Поскольку модель требуется в трёх view, чтобы не передавать одну model через все экраны, было принято решение создать синглтон
    
    static let shared = ScheduleSettlementPickerModel()
    private init() {}
    
    typealias Settlement = Components.Schemas.Settlement
    typealias Station = Components.Schemas.Station
    
    private let model: SettlementsModel = SettlementsModel.shared
    
//    MARK: временное решение, пока нет необходимости связывать View с API
    
    private var settlements: [Settlement] = [Settlement(title: "Москва", stations: [.init(title: "Белорусский вокзал"), .init(title: "Казанский вокзал"), .init(title: "Киевский вокзал")]), Settlement(title: "Санкт-Петербург", stations: [.init(title: "Финляндский вокзал"), .init(title: "Московский вокзал")]), Settlement(title: "Прага")]
    
    private var selectedFrom: SettlementAndStation?
    private var selectedTo: SettlementAndStation?
    
    private func getSettlement(withName title: String) -> Settlement? {
        return settlements.first(where: {$0.title == title})
    }
    
    private func getStation(from settlement: Settlement, withName title: String) -> Station? {
        return settlement.stations?.first(where: {$0.title == title})
    }

    func getCitiesString() -> [String] {
        settlements.compactMap {
            $0.title
        }
    }
    
    func getStationsString(for city: String) -> [String] {
        guard let city = settlements.first(where: {$0.title == city}) else {
            return []
        }
        return city.stations?.compactMap {
            $0.title
        } ?? []
    }
    
    func makeSelection(settlement settlementName: String, station: String, type: SelectionType) {
        guard let settlement = getSettlement(withName: settlementName),
              let station = getStation(from: settlement, withName: station) else {
            return
        }
        
        switch type {
        case .from:
            selectedFrom = .init(selectedSettlement: settlement, selectedStation: station)
        case .to:
            selectedTo = .init(selectedSettlement: settlement, selectedStation: station)
        }
    }
    
    func getSelectionString(type: SelectionType) -> String {
        switch type {
        case .from:
            selectedFrom?.selectionText ?? ""
        case .to:
            selectedTo?.selectionText ?? ""
        }
    }
}

protocol ScheduleSettlementSelectModelProtocol {
    func getCitiesString() -> [String]
}

protocol ScheduleStationSelectModelProtocol {
    func getStationsString(for city: String) -> [String]
    func makeSelection(settlement: String, station: String, type: SelectionType)
}
