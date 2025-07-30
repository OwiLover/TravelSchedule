//
//  CarriersCardView.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/30/25.
//
import SwiftUI

struct CarriersCardView: View {
    
    @Environment(ErrorHandlerModel.self) var errorHandler: ErrorHandlerModel?
    
    var body: some View {
        if let error = errorHandler?.error {
            switch error {
            case .Internet:
                InternetErrorView()
            case .Server:
                ServerErrorView()
            }
        } else {
            Text("CarriersCardView")
        }
    }
}
