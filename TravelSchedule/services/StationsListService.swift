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
            
            let stationsListCount = stationsList.countries?.count ?? 0
//          MARK: Лимит поставлен, поскольку в противном случае консоль вывода зависает
            let limit = stationsListCount > 10 ? 10 : stationsListCount
            let stationsListCut = stationsList.countries?[0...limit]

            print("Successfully fetched Stations list: \(stationsListCut ?? [])")
        } catch {
            print("Error fetching Stations list: \(error)")
        }
    }
}
