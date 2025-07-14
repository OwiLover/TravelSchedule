//
//  ThreadService.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/14/25.
//

import OpenAPIURLSession
import OpenAPIRuntime
import Foundation

typealias ThreadStationsResponse = Components.Schemas.ThreadStationsResponse

protocol ThreadStationsServiceProtocol {
    func getThreadStations(uid: String, date: Date) async throws -> ThreadStationsResponse
}

final class ThreadStationsService: ThreadStationsServiceProtocol {
    
    private let apiKey: String
    private let client: Client
    
    init(client: Client, apiKey: String) {
        self.apiKey = apiKey
        self.client = client
    }
    
    func getThreadStations(uid: String, date: Date = Date()) async throws -> ThreadStationsResponse {
        let result = try await self.client.getThreadStations(query: .init(
            apikey: self.apiKey,
            uid: uid,
        ))
        
        return try result.ok.body.json
    }
}

func testFetchThreadStations() {
    Task {
        do {
//          MARK: несмотря на описание в документации, данный запрос возвращает время не в ISO8601, в связи с этим было принято решение написать кастомный dateTransporter
            let client = Client(
                serverURL: try Servers.Server1.url(),
                configuration: Configuration(dateTranscoder: CustomDateTranscoder()),
                transport: URLSessionTransport()
            )
            let service = ThreadStationsService(
                client: client,
                apiKey: ApiHelper.apiKey,
            )
            
            print("Fetching Thread Stations...")
            let threadStations = try await service.getThreadStations(uid: "6709x6710_1_9602494_g25_4")

            print("Successfully fetched Thread Stations: \(threadStations)")
        } catch {
            print("Error fetching Thread Stations: \(error)")
        }
    }
}
