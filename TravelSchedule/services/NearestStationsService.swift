//
//  NearestStationsService.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/2/25.
//
import OpenAPIRuntime
import OpenAPIURLSession

typealias NearestStations = Components.Schemas.Stations

protocol NearestStationsServiceProtocol {
  func getNearestStations(lat: Double, lng: Double, distance: Int) async throws -> NearestStations
}

final class NearestStationsService: NearestStationsServiceProtocol {
  private let client: Client
  private let apiKey: String
  
  init(client: Client, apiKey: String) {
    self.client = client
    self.apiKey = apiKey
  }
  
  func getNearestStations(lat: Double, lng: Double, distance: Int) async throws -> NearestStations {

    let result = try await client.getNearestStations(query: .init(
        apikey: apiKey,
        lat: lat,
        lng: lng,
        distance: distance
    ))
    
    return try result.ok.body.json
  }
}

func testFetchNearestStations() {
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = NearestStationsService(
                client: client,
                apiKey: ApiHelper.apiKey
            )
            
            print("Fetching stations...")
            let stations = try await service.getNearestStations(
                lat: 59.864177,
                lng: 30.319163,
                distance: 50
            )

            print("Successfully fetched stations: \(stations)")
        } catch {
            print("Error fetching stations: \(error)")
        }
    }
}
