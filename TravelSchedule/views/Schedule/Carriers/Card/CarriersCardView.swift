//
//  CarriersCardView.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/30/25.
//
import SwiftUI

struct CarriersCard {
    var image: String
    var name: String
    var email: String
    var phone: String
}

struct CarriersCardView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Environment(ErrorHandlerModel.self) var errorHandler: ErrorHandlerModel?
    
    let cardInfo: CarriersCard
    
    private let nameFont: Font = FontStyleHelper.bold.getStyledFont(size: 24)
    private let infoHeaderFont: Font = FontStyleHelper.regular.getStyledFont(size: 17)
    private let detailsFont: Font = FontStyleHelper.regular.getStyledFont(size: 12)
    
    var body: some View {
        ErrorsHandlerView {
            mainView
        }
        .background(Color.ypWhite)
    }
    
    init(cardInfo: CarriersCard?) {
        self.cardInfo = cardInfo ?? CarriersCard(image: "", name: "", email: "", phone: "")
    }
    
    private var mainView: some View {
        VStack(spacing: 16) {
            Image(cardInfo.image)
            
            makeCarriersNameElement(name: cardInfo.name)
            
            makeInfoElement(header: "E-mail", details: cardInfo.email)
            makeInfoElement(header: "Телефон", details: cardInfo.phone)
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
    let cardInfo = CarriersCard(image: "RZDBigIcon", name: "RZD", email: "someemail@mail.com", phone: "+7123456789")
    CarriersCardView(cardInfo: cardInfo)
}
