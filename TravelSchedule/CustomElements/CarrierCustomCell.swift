//
//  CarrierCustomCell.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/28/25.
//

import SwiftUI



struct CustomCarrierCell: View, Identifiable {
    let id: UUID = UUID()
    
    init(carrierInfo: CarrierInfo, action: ((_: CarriersCard) -> Void)? = nil) {
        self.carrierInfo = carrierInfo
        self.action = action
    }
    
    var carrierInfo: CarrierInfo
    
    var action: ((_: CarriersCard) -> Void)?
    
    private var fontName: Font = FontStyleHelper.regular.getStyledFont(size: 17)
    private var fontDetails: Font = FontStyleHelper.regular.getStyledFont(size: 12)
    
    private var topInfo: some View {
        HStack(alignment: .top) {
            Image(data: carrierInfo.imageData)
                .resizable()
                .aspectRatio(4/4, contentMode: .fill)
                .frame(width: 38, height: 38)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 0) {
                Spacer(minLength: 0)
                Text(carrierInfo.name).font(fontName)
                    .foregroundStyle(.ypBlackConstant)
                if !carrierInfo.importantInfo.isEmpty {
                    Text(carrierInfo.importantInfo).font(fontDetails).foregroundStyle(.ypRedConstant)
                }
                Spacer(minLength: 0)
            }
            Spacer()
            Text(carrierInfo.date).font(fontDetails)
                .foregroundStyle(.ypBlackConstant)
        }
        .frame(height: 38)
    }
    
    private var bottomInfo: some View {
        HStack(alignment: .center, spacing: 5) {
            Text(carrierInfo.timeStart)
                .foregroundStyle(.ypBlackConstant)
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.ypGrayConstant)
            Text("\(carrierInfo.hoursTotal) часов")
                .foregroundStyle(.ypBlackConstant)
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.ypGrayConstant)
            Text(carrierInfo.timeEnd)
                .foregroundStyle(.ypBlackConstant)
        }
    }
    
    var body: some View {
        Button {
            action?(carrierInfo.carrierCard)
        } label: {
            VStack(spacing: 4) {
                topInfo
                    .padding(EdgeInsets(top: 14, leading: 14, bottom: 0, trailing: 7))
                bottomInfo
                    .padding(.all, 14)
            }
        }
        .background(.ypLightGrayConstant)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

#Preview {
    Spacer()
//    CustomCarrierCell(name: "ФПК", image: "FGKIcon", date: "21 Августа", timeStart: "1:00", timeEnd: "13:00", timeTotal: "12 часов", importantInfo: "Пересадка в Костроме")
    Spacer()
}
