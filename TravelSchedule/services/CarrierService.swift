//
//  CarrierService.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/11/25.
//
import OpenAPIURLSession
import OpenAPIRuntime

typealias CarrierResponse = Components.Schemas.CarrierResponse

protocol CarrierServiceProtocol {
    func getCarriers(code: Int) async throws -> CarrierResponse
}

final class CarrierService: CarrierServiceProtocol {
    
    private let apiKey: String
    private let client: Client
    
    init(client: Client, apiKey: String) {
        self.apiKey = apiKey
        self.client = client
    }
    
    func getCarriers(code: Int) async throws -> CarrierResponse {
        let result = try await self.client.getCarrierInfo(query: .init(apikey: apiKey, code: code))
        
        return try result.ok.body.json
    }
}

func testFetchCarriers() {
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = CarrierService(
                client: client,
                apiKey: ApiHelper.apiKey
            )
            
            print("Fetching carriers...")
            let carriers = try await service.getCarriers(code: 1332)

            print("Successfully fetched carriers: \(carriers)")
        } catch {
            print("Error fetching carriers: \(error)")
        }
    }
}
