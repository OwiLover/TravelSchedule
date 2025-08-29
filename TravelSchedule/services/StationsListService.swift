//
//  StationsListService.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/10/25.
//

import OpenAPIRuntime
import OpenAPIURLSession
import Foundation

typealias StationsList = Components.Schemas.AllStationsResponse

protocol StationsListServiceProtocol {
    func getAllStations(format: String) async throws -> StationsList
}

final class StationsListService: StationsListServiceProtocol {
    let client: Client
    let apiKey: String
    
    init(client: Client, apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }
    
    func getAllStations(format: String = "json") async throws -> StationsList {
        let response = try await client.getAllStations(query: .init(apikey: apiKey, format: format))
        
        let htmlResponse = try response.ok.body.html

        let rawData = try await Data(collecting: htmlResponse, upTo: .max)
        let decodedData = try JSONDecoder().decode(StationsList.self, from: rawData)

        return decodedData
    }
}

func testFetchStationsList() {
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = StationsListService(
                client: client,
                apiKey: ApiHelper.apiKey
            )
            
            print("Fetching stations list...")
            let stationsList = try await service.getAllStations()
            
            var russia: Components.Schemas.Country?
            
            let _ = stationsList.countries?.first { country in
                if country.title == "Россия" {
                    russia = country
                    return true
                }
                return false
            }
            var settlementsArray: [Components.Schemas.Settlement] = []
            
            russia?.regions?.forEach { region in
                for settlement in region.settlements ?? [] {
                    let stationsFiltered = settlement.stations?.filter { station in
                        station.station_type == "train_station"
                    }
                    guard let stationsFiltered, !stationsFiltered.isEmpty else { continue }
                    var settlementFiltered = settlement
                    settlementFiltered.stations = stationsFiltered
                    settlementsArray.append(settlementFiltered)
                }
            }

            print("Successfully fetched Stations list: \(settlementsArray.count)")
        } catch {
            print("Error fetching Stations list: \(error)")
        }
    }
}
