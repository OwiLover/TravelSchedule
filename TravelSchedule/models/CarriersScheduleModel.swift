//
//  CarriersScheduleModel.swift
//  TravelSchedule
//
//  Created by Owi Lover on 8/27/25.
//

import OpenAPIURLSession
import Foundation

struct CarrierInfo: Identifiable, Sendable {
    let id: UUID = UUID()
    let name: String
    let imageData: Data?
    let date: String
    let timeStart: String
    let timeEnd: String
    let hoursTotal: Int
    let importantInfo: String
    
    let carrierCard: CarriersCard
}

struct CarriersCard: Sendable {
    var image: Data?
    var name: String
    var email: String
    var phone: String
}

actor CarriersScheduleModel: CarriersScheduleModelProtocol {
    typealias Carrier = Components.Schemas.Carrier
    typealias CarrierResponse = Components.Schemas.CarrierResponse
    
    typealias Station = Components.Schemas.Station
    
    typealias Segments = Components.Schemas.Segments
    typealias Segment = Components.Schemas.Segment
    
    private var task: Task<Segments?, Never>?
    private var taskCarriersCard: Task<CarrierResponse?, Never>?
    
    private var response: Segments?
    private var isFetched = false
    private var carrierImageCache: [String: Data] = [:]
    private var carrierResponseArray: [Int: CarrierResponse] = [:]
    
    private var customDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        return formatter
    }
    
    private var customTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    func fetchThread(stationFrom: Station, stationTo: Station) async -> Segments? {
        guard let codeFrom = stationFrom.codes?.yandex_code, let codeTo = stationTo.codes?.yandex_code else {
            return nil
        }
        
        guard task == nil, !isFetched else {
            if isFetched {
                return response
            }
            let _ = await task?.value
            return response
        }
        
        self.task = Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                let service = ScheduleSegmentService(
                    client: client,
                    apiKey: ApiHelper.apiKey
                )
                
                let threadStationResponse = try await service.getScheduleSegment(from: codeFrom, to: codeTo)
                
                return threadStationResponse
            } catch {
                return nil
            }
        }
        self.response = await task?.value
        self.isFetched = true
        return response
    }
    
    func getCarrierInfos(stationFrom: Station, stationTo: Station) async -> [CarrierInfo] {
        let response = await fetchThread(stationFrom: stationFrom, stationTo: stationTo)

        var carrierInfos: [CarrierInfo] = []

        for segment in response?.segments ?? [] {
            
            guard let departure = segment.departure, let arrival = segment.arrival else { continue }
            
            if let hasTransfers = segment.has_transfers, hasTransfers {
                guard let transfers = segment.transfers, let segmentExtra = segment.details?.first else { continue }
                
                var transitionsString: String = ""
                        
                transfers.enumerated().forEach { (index, transition) in
                    if let title = transition.title {
                        let titlePrep = CityPrepositionalHelper.toPrepositional(title)
                        if index == 0 {
                            transitionsString += "\(titlePrep)"
                        } else if index == transfers.count - 1 {
                            transitionsString += " и \(titlePrep)"
                        } else {
                            transitionsString += ", \(titlePrep)"
                        }
                    }
                }
                let firstTwo = transitionsString.lowercased().prefix(2)
                
                let voSet: Set<String> = ["вл", "вк", "вс", "вт", "вф", "вр"]
                
                let prefix = voSet.contains(String(firstTwo)) ? "во" : "в"

                let additionalInfo: String? = transitionsString.isEmpty ? nil : "С пересадкой \(prefix) \(transitionsString)"
                
                guard let card = await createCarrierInfo(departure: departure, arrival: arrival, segment: segmentExtra, additionalInfo: additionalInfo, hasTransfers: hasTransfers) else { continue }
                carrierInfos.append(card)
                
                continue
            }
            
            guard let card = await createCarrierInfo(departure: departure, arrival: arrival, segment: segment) else { continue }
            carrierInfos.append(card)
        }
        print(carrierInfos)
        return carrierInfos
    }
    
    private func fetchCarrier(id: Int) async -> CarrierResponse? {
        let card = carrierResponseArray[id]
        
        guard card == nil else {
            return card
        }
        
        self.taskCarriersCard = Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                let service = CarrierService(
                    client: client,
                    apiKey: ApiHelper.apiKey
                )
                
                let carrierInfoResponse = try await service.getCarriers(code: id)
                
                carrierResponseArray[id] = carrierInfoResponse
                
                return carrierInfoResponse
            } catch {
                return nil
            }
        }
        
        return await taskCarriersCard?.value
    }
    
    private func createCarrierInfo(departure: Date, arrival: Date, segment: Segment, additionalInfo: String? = nil, hasTransfers: Bool = false) async -> CarrierInfo? {
        guard let thread = segment.thread, var carrier = thread.carrier else { return nil }

        let dateStart = customDateFormatter.string(from: departure)
        
        let timeStart = customTimeFormatter.string(from: departure)
        let timeEnd = customTimeFormatter.string(from: arrival)
    
        let timeTotal = Int(DateInterval(start: departure, end: arrival).duration) / 60 / 60
        
        if hasTransfers, let id = carrier.code {
            let carrierResponse = await fetchCarrier(id: id)
            carrier = carrierResponse?.carrier ?? carrier
        }
        
        let carrierImageString: String? = carrier.logo
        
        var carrierName: String?
        
        if let name = carrier.title {
            carrierName = !name.isEmpty ? name : nil
        }
        
        var email: String?
        if let emailString = carrier.email {
            email = !emailString.isEmpty ? emailString : nil
        }
        
        var phone: String?
        if let phoneString = carrier.phone {
            phone = !phoneString.isEmpty ? phoneString : nil
        }
    
        var imageData: Data?
        
        if let carrierImageString {
            if let data = carrierImageCache[carrierImageString] {
                imageData = data
            } else if let url = URL(string: carrierImageString) {
                let urlRequest = URLRequest(url: url)
                async let requestWithData = try? await URLSession.shared.data(for: urlRequest)
                imageData = await requestWithData?.0 ?? nil
                
                carrierImageCache[carrierImageString] = imageData
            }
        }
        
        let carrierCard = CarriersCard(image: imageData, name: carrierName ?? "Неизвестный", email: email ?? "Не найдено", phone: phone ?? "Не найдено")
        
        return CarrierInfo(name: carrierName ?? "Неизвестный", imageData: imageData, date: dateStart, timeStart: timeStart, timeEnd: timeEnd, hoursTotal: timeTotal, importantInfo: additionalInfo ?? "", carrierCard: carrierCard)
    }
}

protocol CarriersScheduleModelProtocol: Actor {    
    typealias Station = Components.Schemas.Station
    typealias Segments = Components.Schemas.Segments
    
    func fetchThread(stationFrom: Station, stationTo: Station) async -> Segments?
    func getCarrierInfos(stationFrom: Station, stationTo: Station) async -> [CarrierInfo]
}
