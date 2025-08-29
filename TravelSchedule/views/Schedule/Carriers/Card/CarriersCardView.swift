//
//  CarriersCardView.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/30/25.
//

import SwiftUI

struct CarriersCardView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Environment(ErrorHandlerModel.self) var errorHandler: ErrorHandlerModel?
    
    @State var viewModel: CarrierCardViewModelProtocol
    
    init(cardInfo: CarriersCard?) {
        let card = cardInfo ?? CarriersCard(image: nil, name: "", email: "", phone: "")
        self.viewModel = CarrierCardViewModel(cardInfo: card)
    }
    
    private let nameFont: Font = FontStyleHelper.bold.getStyledFont(size: 24)
    private let infoHeaderFont: Font = FontStyleHelper.regular.getStyledFont(size: 17)
    private let detailsFont: Font = FontStyleHelper.regular.getStyledFont(size: 12)
    
    var body: some View {
        ErrorsHandlerView {
            mainView
        }
        .background(Color.ypWhite)
    }

    
    private var mainView: some View {
        VStack(spacing: 16) {
            Image(data: viewModel.getCarrierImage())
                .resizable()
                .scaledToFit()
                .frame(height: 104)
                .clipShape(RoundedRectangle(cornerRadius: 24))
            makeCarriersNameElement(name: viewModel.getCarrierName())
            
            makeInfoElement(header: "E-mail", details: viewModel.getCarrierEmail())
            makeInfoElement(header: "Телефон", details: viewModel.getCarrierPhone())
            Spacer()
        }
        .padding(.all, 16)
        .navigationTitle("Информация о перевозчике")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CustomBackButton(action: {
                    dismiss()
                })
            }
        }
    }
    
    func makeCarriersNameElement(name: String) -> some View {
        HStack {
            Text(name)
                .font(nameFont)
                .foregroundStyle(.ypBlack)
            Spacer()
        }
    }
    
    func makeInfoElement(header: String, details: String) -> some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text(header)
                    .font(infoHeaderFont)
                    .foregroundStyle(.ypBlack)
                Text(details)
                    .font(detailsFont)
                    .foregroundStyle(.ypBlueConstant)
                
            }
            Spacer()
        }
    }
}

#Preview {
//    let cardInfo = CarriersCard(image: "RZDBigIcon", name: "RZD", email: "someemail@mail.com", phone: "+7123456789")
//    CarriersCardView(cardInfo: cardInfo)
}
