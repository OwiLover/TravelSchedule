//
//  CarrierSelectView.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/28/25.
//

import SwiftUI

struct CarrierSelectView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var fromModel: ScheduleSettlementPickerModel
    @Bindable var toModel: ScheduleSettlementPickerModel
    
    var elements: [String] = ["z", "x", "c"]
    
    @State var isFiltered: Bool = true
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 0) {
                Text("\(fromModel.selectionText) → \(toModel.selectionText)")
                    .font(FontStyleHelper.bold.getStyledFont(size: 24))
                Spacer()
            }
            ZStack(alignment: .bottom) {
                CarrierList
                Button(action: { dismiss() }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.ypBlueConstant)
                        HStack(spacing: 4) {
                            Text("Уточнить время").font(FontStyleHelper.bold.getStyledFont(size: 17))
                                .foregroundStyle(.ypWhiteConstant)
                            if isFiltered {
                                Rectangle()
                                    .foregroundStyle(.ypRedConstant)
                                    .frame(width: 8, height: 8)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                                    
                                    
                                    
                            }
                        }
                    }
                }
                .frame(height: 60)
                .padding(.bottom, 24)
            }
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CustomBackButton(action: { dismiss() })
            }
        }
        .background(.ypWhite)
//            .navigationTitle("\(fromModel.selectionText) → \(toModel.selectionText)").navigationBarTitleDisplayMode(.large)
    }
    
    private var CarrierList: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(elements, id: \.self) {
                    element in
                    if element != "x" {
                        CustomCarrierCell(name: "РЖД", image: "RZDIcon", date: "11 января", timeStart: "19:00", timeEnd: "21:00", timeTotal: "2 часа")
                    }
                    else {
                        CustomCarrierCell(name: "ФПК", image: "FGKIcon", date: "21 Августа", timeStart: "01:00", timeEnd: "13:00", timeTotal: "12 часов", importantInfo: "Пересадка в Костроме")
                    }
                }
            }
        }
    }
}

#Preview {
    CarrierSelectView(fromModel: ScheduleSettlementPickerModel(), toModel: ScheduleSettlementPickerModel())
}
