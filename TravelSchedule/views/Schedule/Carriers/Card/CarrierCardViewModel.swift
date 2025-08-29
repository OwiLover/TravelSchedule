//
//  CarrierCardViewModel.swift
//  TravelSchedule
//
//  Created by Owi Lover on 8/23/25.
//

import SwiftUI

@MainActor
@Observable final class CarrierCardViewModel: CarrierCardViewModelProtocol {
    private var cardInfo: CarriersCard
    
    init(cardInfo: CarriersCard) {
        self.cardInfo = cardInfo
    }
    
    func getCarrierName() -> String {
        cardInfo.name
    }
    
    func getCarrierImage() -> Data? {
        cardInfo.image
    }
    
    func getCarrierEmail() -> String {
        cardInfo.email
    }
    
    func getCarrierPhone() -> String {
        cardInfo.phone
    }
}

@MainActor
protocol CarrierCardViewModelProtocol {
    func getCarrierName() -> String
    func getCarrierImage() -> Data?
    func getCarrierEmail() -> String
    func getCarrierPhone() -> String
}
