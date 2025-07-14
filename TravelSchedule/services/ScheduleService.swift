//
//  ScheduleService.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/11/25.
//

import OpenAPIURLSession
import OpenAPIRuntime
import Foundation

typealias ScheduleResponse = Components.Schemas.ScheduleResponse

protocol ScheduleServiceProtocol {
    func getSchedule(stationCode: String, date: Date) async throws -> ScheduleResponse
}

final class ScheduleService: ScheduleServiceProtocol {
    
    private let apiKey: String
    private let client: Client
    
    init(client: Client, apiKey: String) {
        self.apiKey = apiKey
        self.client = client
    }
    
    func getSchedule(stationCode: String, date: Date = Date()) async throws -> ScheduleResponse {
        let result = try await self.client.getStationSchedule(query: .init(apikey: apiKey,
                                                                           station: stationCode,date: date.ISO8601Format()))
        return try result.ok.body.json
    }
}

func testFetchSchedule() {
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport(),
            )
            let service = ScheduleService(
                client: client,
                apiKey: ApiHelper.apiKey
            )
            
            print("Fetching schedule...")
            let schedule = try await service.getSchedule(stationCode: "s9602494")

            print("Successfully fetched schedule: \(schedule)")
        } catch {
            print("Error fetching schedule: \(error)")
        }
    }
}
