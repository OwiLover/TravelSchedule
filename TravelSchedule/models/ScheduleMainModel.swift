////
////  ScheduleMainModel.swift
////  TravelSchedule
////
////  Created by Owi Lover on 7/26/25.
////
//import SwiftUI
//
//@Observable class ScheduleSettlementMainModel {
//    typealias Settlement = Components.Schemas.Settlement
//    typealias Station = Components.Schemas.Station
//    
//    private var selectedSettlement: Settlement?
//    private var selectedStation: Station?
//    
//    var selectionText: String {
//        get {
//            guard let cityName = selectedStation?.title, let stationName = selectedSettlement?.title else {
//                return ""
//            }
//            return "\(cityName) (\(stationName))"
//        }
//        set {
//            ""
//        }
//    }
//    
////    private var elements: [City] = [City(name: "Москва", stations: ["Белорусский вокзал", "Казанский вокзал", "Киевский вокзал", "Ленинградский вокзал", "Ярославский вокзал", "Курский вокзал", "Павелецкий вокзал", "Рижский вокзал", "Савеловский вокзал", "Восточный вокзал"]),
////                                    City(name: "Санкт-Петербург", stations: []),
////                                    City(name: "Нью-Йорк", stations: []),
////                                    City(name: "Лондон", stations: []),
////                                    City(name: "Париж", stations: [])]
//    
//    func selectSettlement(withName title: String) {
//        self.selectedSettlement = settlements.first(where: {$0.title == title})
//    }
//    
//    func selectStation(withName title: String) {
//        guard let selectedSettlement else {
//            self.selectedStation = nil
//            return
//        }
//        self.selectedStation = selectedSettlement.stations?.first(where: {$0.title == title})
//    }
//    
//    func getCitiesString() -> [String] {
//        settlements.compactMap {
//            $0.title
//        }
//    }
//    
//    func getStationsString(for city: String) -> [String] {
//        guard let city = settlements.first(where: {$0.title == city}) else {
//            return []
//        }
//        return city.stations?.compactMap {
//            $0.title
//        } ?? []
//    }
//    
//    func filterCities(text: String) {
//        filteredElements = text.isEmpty ? settlements : settlements.filter {
//            $0.title?.lowercased().contains(text.lowercased()) ?? false
//        }
//    }
//}
