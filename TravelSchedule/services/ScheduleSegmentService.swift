//
//  SearchService.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/14/25.
//

import OpenAPIURLSession
import OpenAPIRuntime
import Foundation

typealias Segments = Components.Schemas.Segments

protocol ScheduleSegmentServiceProtocol {
    func getScheduleSegment(from: String, to: String, date: Date) async throws -> Segments
}

final class ScheduleSegmentService: ScheduleSegmentServiceProtocol {
    
    private let apiKey: String
    private let client: Client
    
    init(client: Client, apiKey: String) {
        self.apiKey = apiKey
        self.client = client
    }
    
    func getScheduleSegment(from: String, to: String, date: Date = Date()) async throws -> Segments {
        let result = try await self.client.getScheduleSegments(query: .init(apikey: apiKey,
                                                                            from: from,
                                                                            to: to,
                                                                            date: date.ISO8601Format()))
        return try result.ok.body.json
    }
}

func testFetchScheduleSegment() {
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport(),
            )
            let service = ScheduleSegmentService(
                client: client,
                apiKey: ApiHelper.apiKey
            )
            
            print("Fetching schedule...")
            let copyright = try await service.getScheduleSegment(from: "s9602494", to: "s9602655")

            print("Successfully fetched schedule: \(copyright)")
        } catch {
            print("Error fetching schedule: \(error)")
        }
    }
}
