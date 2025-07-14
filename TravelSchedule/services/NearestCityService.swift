//
//  NearestCityService.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/14/25.
//

import OpenAPIURLSession
import OpenAPIRuntime

typealias NearestCityResponse = Components.Schemas.NearestCityResponse

protocol NearestCityServiceProtocol {
    func getNearestCity(lat: Double, lng: Double, distance: Int?) async throws -> NearestCityResponse
}

final class NearestCityService: NearestCityServiceProtocol {
    
    private let apiKey: String
    private let client: Client
    
    init(client: Client, apiKey: String) {
        self.apiKey = apiKey
        self.client = client
    }
    
    func getNearestCity(lat: Double, lng: Double, distance: Int? = nil) async throws -> NearestCityResponse {
        let result = try await self.client.getNearestCity(query: .init(
            apikey: self.apiKey,
            lat: lat,
            lng: lng,
            distance: distance
        ))
        
        return try result.ok.body.json
    }
}

func testFetchNearestCity() {
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = NearestCityService(
                client: client,
                apiKey: ApiHelper.apiKey
            )
            
            print("Fetching nearest city...")
            let nearestCity = try await service.getNearestCity(lat: 59.864177,
                                                             lng: 30.319163)

            print("Successfully fetched nearest city: \(nearestCity)")
        } catch {
            print("Error fetching nearest city: \(error)")
        }
    }
}
