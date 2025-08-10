//
//  CarrierSelectView.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/28/25.
//

import SwiftUI

// MARK: На данный момент фильтрации не действуют, поскольку это не является требованием спринта

struct CarrierSelectView: View {
    @Environment(ErrorHandlerModel.self) var errorHandler: ErrorHandlerModel?
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var fromModel: ScheduleSettlementPickerModel
    @Bindable var toModel: ScheduleSettlementPickerModel
    
    @State var selectModel: CarriersFilterSelectModel = CarriersFilterSelectModel()
    @State var isCarriersFilterSelectViewPresented: Bool = false
    @State var isCarriersCardViewPresented: Bool = false
    
    
    var elements: [String] = ["z", "x", "c", "q", "w", "d", "h", "a"]
    
//    MARK: Для тестирования надписи отсутствия вариантов
//    var elements: [String] = []
    
    private let filterButtonHeight: CGFloat = 60
    private let filterButtonBottomPadding: CGFloat = 24
    private let filterStackSpacing: CGFloat = 16
    
    var body: some View {
        if let error = errorHandler?.error {
            switch error {
            case .Internet:
                InternetErrorView()
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            CustomBackButton(action: { dismiss() })
                        }
                    }
            case .Server:
                ServerErrorView()
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            CustomBackButton(action: { dismiss() })
                        }
                    }
            }
        } else {
            VStack(spacing: filterStackSpacing) {
                HStack(spacing: 0) {
                    Text("\(fromModel.selectionText) → \(toModel.selectionText)")
                        .font(FontStyleHelper.bold.getStyledFont(size: 24))
                    Spacer()
                }
                ZStack(alignment: .bottom) {
                    //              MARK: маска добавлена, чтобы список не сильно акцентировал внимание, если находится ниже кнопки
                    if elements.isEmpty {
                        VStack {
                            Spacer()
                            Text("Вариантов нет")
                                .foregroundStyle(.ypBlack)
                                .font(FontStyleHelper.bold.getStyledFont(size: 24))
                            Spacer()
                        }
                        .padding(.bottom, filterButtonHeight + filterButtonBottomPadding + filterStackSpacing)
                    } else {
                        CarrierList
                            .mask(LinearGradient(gradient: Gradient(colors: [.ypWhite, .ypWhite, .ypWhite, .ypWhite, .ypWhite, .ypWhite, .clear]), startPoint: .center, endPoint: .bottom))
                    }
                    Button(action: {
                        isCarriersFilterSelectViewPresented = true
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.ypBlueConstant)
                            HStack(spacing: 4) {
                                Text("Уточнить время").font(FontStyleHelper.bold.getStyledFont(size: 17))
                                    .foregroundStyle(.ypWhiteConstant)
                                if selectModel.isFilteringActive {
                                    Rectangle()
                                        .foregroundStyle(.ypRedConstant)
                                        .frame(width: 8, height: 8)
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                }
                            }
                        }
                    }
                    .frame(height: filterButtonHeight)
                    .padding(.bottom, filterButtonBottomPadding)
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
            .navigationDestination(isPresented: $isCarriersFilterSelectViewPresented) {
                CarriersFilterSelectView(model: selectModel)
            }
            .navigationDestination(isPresented: $isCarriersCardViewPresented) {
                CarriersCardView()
            }
        }
    }
    
    private var CarrierList: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(elements, id: \.self) {
                    element in
                    if ["x", "a", "h"].firstIndex(of: element) == nil {
                        CustomCarrierCell(name: "РЖД", image: "RZDIcon", date: "11 января", timeStart: "19:00", timeEnd: "21:00", timeTotal: "2 часа", action: carrierCellAction)
                    }
                    else {
                        CustomCarrierCell(name: "ФПК", image: "FGKIcon", date: "21 Августа", timeStart: "01:00", timeEnd: "13:00", timeTotal: "12 часов", importantInfo: "Пересадка в Костроме", action: carrierCellAction)
                    }
                }
            }
            Spacer(minLength: filterButtonHeight + 32)
        }
        .scrollIndicators(.hidden)
    }
    
    func carrierCellAction() {
        isCarriersCardViewPresented = true
    }
}

#Preview {
    CarrierSelectView(fromModel: ScheduleSettlementPickerModel(), toModel: ScheduleSettlementPickerModel())
}
