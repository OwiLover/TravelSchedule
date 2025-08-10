//
//  ScheduleMainModel.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/24/25.
//

import SwiftUI

struct City {
    let name: String
    let stations: [String]
}


@Observable final class ScheduleSettlementPickerModel {
    typealias Settlement = Components.Schemas.Settlement
    typealias Station = Components.Schemas.Station
    
//    MARK: временное решение, пока нет необходимости связывать View с API
    
    private var settlements: [Settlement] = [Settlement(title: "Москва", stations: [.init(title: "Белорусский вокзал"), .init(title: "Казанский вокзал"), .init(title: "Киевский вокзал")]), Settlement(title: "Санкт-Петербург", stations: [.init(title: "Финляндский вокзал"), .init(title: "Московский вокзал")]), Settlement(title: "Прага")]
    
    private var selectedSettlement: Settlement?
    private var selectedStation: Station?
    
    
    var selectionText: String {
        get {
            guard let cityName = selectedSettlement?.title, let stationName = selectedStation?.title else {
                return ""
            }
            return "\(cityName) (\(stationName))"
        }
        set {
            return
        }
    }
    
//    private var elements: [City] = [City(name: "Москва", stations: ["Белорусский вокзал", "Казанский вокзал", "Киевский вокзал", "Ленинградский вокзал", "Ярославский вокзал", "Курский вокзал", "Павелецкий вокзал", "Рижский вокзал", "Савеловский вокзал", "Восточный вокзал"]),
//                                    City(name: "Санкт-Петербург", stations: []),
//                                    City(name: "Нью-Йорк", stations: []),
//                                    City(name: "Лондон", stations: []),
//                                    City(name: "Париж", stations: [])]
    
    private func selectSettlement(withName title: String) {
        self.selectedSettlement = settlements.first(where: {$0.title == title})
        self.selectedStation = nil
    }
    
    private func selectStation(withName title: String) {
        guard let selectedSettlement else {
            self.selectedStation = nil
            return
        }
        self.selectedStation = selectedSettlement.stations?.first(where: {$0.title == title})
    }
    
    func swapSettlements( with model: ScheduleSettlementPickerModel) {
        let selectedSettlement = self.selectedSettlement
        let selectedStation = self.selectedStation
        
        self.selectedSettlement = model.selectedSettlement
        self.selectedStation = model.selectedStation
        
        model.selectedSettlement = selectedSettlement
        model.selectedStation = selectedStation
    }
    
    func checkIfAllSelected() -> Bool {
        selectedSettlement != nil && selectedStation != nil
    }
    
    func printElements() {
        print("Selected settlement: \(selectedSettlement?.title ?? "None")")
        print("Selected station: \(selectedStation?.title ?? "None")")
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
    
    func makeSelection(settlement: String, station: String) {
        selectSettlement(withName: settlement)
        selectStation(withName: station)
    }
}
