//
//  CopyrightService.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/9/25.
//
import OpenAPIURLSession
import OpenAPIRuntime

typealias Copyright = Components.Schemas.Copyrights

protocol CopyrightServiceProtocol {
    func getCopyright(format: String) async throws -> Copyright
}

final class CopyrightService: CopyrightServiceProtocol {
    
    private let apiKey: String
    private let client: Client
    
    init(client: Client, apiKey: String) {
        self.apiKey = apiKey
        self.client = client
    }
    
//  MARK: Не совсем понятно, как лучше сделать решение. Сервис отдаёт один обёрнутый Copyright элемент
//  Лучше предоставлять доступ к "обёртке" на случай добавления лишних элементов или вытаскивать из запроса единственный элемент и предоставлять к работе?
    
    func getCopyright(format: String = "json") async throws -> Copyright {
        let result = try await self.client.getCopyright(query: .init(
            apikey: self.apiKey, format: format))
        
        return try result.ok.body.json
    }
}

func testFetchCopyright() {
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = CopyrightService(
                client: client,
                apiKey: ApiHelper.apiKey
            )
            
            print("Fetching copyrights...")
            let copyright = try await service.getCopyright()

            print("Successfully fetched copyright: \(copyright)")
        } catch {
            print("Error fetching copyright: \(error)")
        }
    }
}
