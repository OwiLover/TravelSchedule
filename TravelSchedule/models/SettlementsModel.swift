//
//  StationsModel.swift
//  TravelSchedule
//
//  Created by Owi Lover on 8/25/25.
//

import OpenAPIRuntime
import OpenAPIURLSession

actor SettlementsModel {
    typealias Country = Components.Schemas.Country
    typealias Settlement = Components.Schemas.Settlement
    typealias Station = Components.Schemas.Station
    
    static let shared = SettlementsModel()
    
    private init() {}
    
    private var task: Task<[Settlement], Never>?
    
    private var settlements: [Settlement] = []
    
    private var isFetched: Bool = false
    
    func getSettlements() async -> [Settlement] {
        guard task == nil, !isFetched else {
            if isFetched {
                return settlements
            }
            let result = await task?.value ?? []
            return result
        }
        
        self.task = Task {
            var russia: Country?
            
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                let service = StationsListService(
                    client: client,
                    apiKey: ApiHelper.apiKey
                )
                
                let allCountries = try await service.getAllStations()
                
                let _ = allCountries.countries?.first { country in
                    if country.title == "Россия" {
                        russia = country
                        return true
                    }
                    return false
                }
            } catch {
                return [Settlement]()
            }
            
            var settlementsArray: [Settlement] = []
            
            russia?.regions?.forEach { region in
                for settlement in region.settlements ?? [] {
                    guard let settlementTitle = settlement.title, !settlementTitle.isEmpty else { continue }
                    let stationsFiltered = settlement.stations?.filter { station in
                        guard station.station_type == "train_station", station.transport_type == "train", let direction = station.direction, !direction.isEmpty else { return false }
                        return true
                    }
                    guard let stationsFiltered, !stationsFiltered.isEmpty else { continue }
                    var settlementFiltered = settlement
                    settlementFiltered.stations = stationsFiltered
                    settlementsArray.append(settlementFiltered)
                }
            }
            return settlementsArray
        }
        
        guard let result = await task?.value else { return [Settlement]() }
        self.settlements = result
        isFetched = true
        return result
    }
    
    func getSettlementsString() async -> [String] {
        await getSettlements().compactMap { $0.title }
    }
    
    func getSettlementStations(settlementName name: String) async -> [Station] {
        let settlement = await getSettlements().first { settlement in
            guard let title = settlement.title else {
                return false
            }
            return title == name
        }
        return settlement?.stations ?? []
    }
    
    func getSettlementAndStation(settlementName: String, stationName: String) async -> (settlement: Settlement, station: Station)? {
        let settlements = await getSettlements()
        
        let settlement = settlements.first { settlement in
            guard let title = settlement.title else {
                return false
            }
            return title == settlementName
        }
        
        let station = settlement?.stations?.first { $0.title == stationName }
        
        guard let station, let settlement else {
            return nil
        }
        
        return (settlement: settlement, station: station)
    }
}
