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
    
    @State private var viewModel: CarrierSelectViewModelProtocol
    
    init(viewModel: CarrierSelectViewModelProtocol? = nil, settlementFrom: SettlementAndStation, settlementTo: SettlementAndStation) {
        self.viewModel = viewModel ?? CarrierSelectViewModel(settlementFrom: settlementFrom, settlementTo: settlementTo)
    }
    
    private let filterButtonHeight: CGFloat = 60
    private let filterButtonBottomPadding: CGFloat = 24
    private let filterStackSpacing: CGFloat = 16
    private let fontForLoading: Font = FontStyleHelper.regular.getStyledFont(size: 17)
    
    var body: some View {
        ErrorsHandlerView {
                mainView
        }
        .background(.ypWhite)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CustomBackButton(action: { dismiss() })
            }
        }
        .navigationDestination(isPresented: $viewModel.isCarriersFilterSelectViewPresented) {
            CarriersFilterSelectView(carrierFilters: viewModel.carrierFilters)
        }
        .navigationDestination(isPresented: $viewModel.isCarriersCardViewPresented) {
            CarriersCardView(cardInfo: viewModel.getSelectedCarrier())
        }
        .task {
            Task {
                await viewModel.loadData()
            }
        }
    }
    
    private var mainView: some View {
        VStack(spacing: filterStackSpacing) {
            HStack(spacing: 0) {
                Text(viewModel.getCarriersRouteString())
                    .font(FontStyleHelper.bold.getStyledFont(size: 24))
                Spacer()
            }
            ZStack {
                ZStack(alignment: .bottom) {
                    if viewModel.filteredElements.isEmpty {
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
                        viewModel.presentCarriersFilterSelectView()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.ypBlueConstant)
                            HStack(spacing: 4) {
                                Text("Уточнить время")
                                    .font(FontStyleHelper.bold.getStyledFont(size: 17))
                                    .foregroundStyle(.ypWhiteConstant)
                                if viewModel.isFilteringActive {
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
                .disabled(viewModel.isLoading)
                .opacity(viewModel.isLoading ? 0 : 1)
            VStack {
                Text("Перевозчики загружаются, подождите...")
                    .font(fontForLoading)
                    .foregroundStyle(.ypBlack)
                ProgressView()
            }
            .opacity(viewModel.isLoading ? 1 : 0)
            }
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
    }

    private var CarrierList: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(viewModel.filteredElements) {
                    element in
                    CustomCarrierCell(carrierInfo: element, action: carrierCellAction)
                }
            }
            Spacer(minLength: filterButtonHeight + 32)
        }
        .scrollIndicators(.hidden)
    }
    
    func carrierCellAction(carrierCard: CarriersCard) {

        viewModel.selectCarrier(carrierCard)
    }
}

#Preview {
//    CarrierSelectView(fromModel: ScheduleSettlementPickerModel(), toModel: ScheduleSettlementPickerModel())
}
