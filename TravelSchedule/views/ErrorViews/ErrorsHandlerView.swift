//
//  ErrorsHandlerView.swift
//  TravelSchedule
//
//  Created by Owi Lover on 8/5/25.
//


import SwiftUI

//MARK: поскольку экран не имеет внутренней логики, создание viewModel не имеет смысла

struct ErrorsHandlerView<presentedView: View>: View {
    @ViewBuilder let content: presentedView
    @Environment(ErrorHandlerModel.self) var errorHandler: ErrorHandlerModel?
    
    var body: some View {
        switch errorHandler?.error {
        case .Internet:
            InternetErrorView()
        case .Server:
            ServerErrorView()
        case .none:
            content
        }
    }
}
