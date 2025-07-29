//
//  CarrierCustomCell.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/28/25.
//

import SwiftUI

struct CustomCarrierCell: View {
    
    init(name: String, image: String, date: String, timeStart: String, timeEnd: String, timeTotal: String, importantInfo: String = "") {
        self.name = name
        self.image = image
        self.date = date
        self.timeStart = timeStart
        self.timeEnd = timeEnd
        self.timeTotal = timeTotal
        self.importantInfo = importantInfo
    }
    
    var name: String
    var image: String
    var date: String
    var importantInfo: String
    
    var timeStart: String
    var timeEnd: String
    
    var timeTotal: String
    
    private var fontName: Font = FontStyleHelper.regular.getStyledFont(size: 17)
    private var fontDetails: Font = FontStyleHelper.regular.getStyledFont(size: 12)
    
    private var topInfo: some View {
        HStack(alignment: .top) {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 38, height: 38)
            VStack(alignment: .leading, spacing: 0) {
                Spacer(minLength: 0)
                Text(name).font(fontName)
                    .foregroundStyle(.ypBlackConstant)
                if !importantInfo.isEmpty {
                    Text(importantInfo).font(fontDetails).foregroundStyle(.ypRedConstant)
                }
                Spacer(minLength: 0)
            }
            Spacer()
            Text(date).font(fontDetails)
                .foregroundStyle(.ypBlackConstant)
        }
//        .frame(height: 38)
    }
    
    private var bottomInfo: some View {
        HStack(alignment: .center, spacing: 5) {
            Text(timeStart)
                .foregroundStyle(.ypBlackConstant)
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.ypGrayConstant)
            Text(timeTotal)
                .foregroundStyle(.ypBlackConstant)
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.ypGrayConstant)
            Text(timeEnd)
                .foregroundStyle(.ypBlackConstant)
        }
    }
    
    var body: some View {
        VStack(spacing: 4) {
            topInfo
                .padding(EdgeInsets(top: 14, leading: 14, bottom: 0, trailing: 7))
            bottomInfo
                .padding(.all, 14)
        }
        .background(.ypLightGrayConstant)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

#Preview {
    Spacer()
    CustomCarrierCell(name: "ФПК", image: "FGKIcon", date: "21 Августа", timeStart: "1:00", timeEnd: "13:00", timeTotal: "12 часов", importantInfo: "Пересадка в Костроме")
    Spacer()
}
