//
//  CarriersFilterSelectView.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/29/25.
//

import SwiftUI

struct CarriersFilterSelectView: View {
    
    @Environment(ErrorHandlerModel.self) var errorHandler: ErrorHandlerModel?
    @Environment(\.dismiss) private var dismiss
    
    @State var viewModel: CarrierFilterSelectViewModelProtocol
    
    init(carrierFilters: CarrierFilters, viewModel: CarrierFilterSelectViewModelProtocol? = nil) {
        self.viewModel = viewModel ?? CarriersFilterSelectViewModel(carrierFilters: carrierFilters)
    }
    private let sectionFont = FontStyleHelper.bold.getStyledFont(size: 24)
    
    private let optionsFont = FontStyleHelper.regular.getStyledFont(size: 17)
    
    var body: some View {
        ErrorsHandlerView {
            mainView
        }
    }
    private var mainView: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    makeSectionList(info: viewModel.getTimeFiltersInfo())
                    makeSectionList(info: viewModel.getTransitionFilterInfo())
                }
            }
            Button {
                dismiss()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.ypBlueConstant)
                    HStack(spacing: 4) {
                        Text("Применить").font(FontStyleHelper.bold.getStyledFont(size: 17))
                            .foregroundStyle(.ypWhiteConstant)
                    }
                }
            }
            .frame(height: 60)
            .padding(.bottom, 24)
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
        .background(.ypWhite)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CustomBackButton(action: {
                    dismiss()
                })
            }
        }
    }
    func makeSectionList(info: FilterInfo) -> some View {
        Section(info.sectionName) {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(info.filters, id: \.self) { filter in
                    HStack {
                        Text(filter)
                            .font(optionsFont)
                        Spacer()
                        if info.isOnlyOneAllowed { makeFilterButtonOne(filter: filter)
                        } else {
                            makeFilterButtonAll(filter: filter)
                        }
                    }
                    .frame(height: 60)
                }
            }
        }
        .font(sectionFont)
    }
    
    private func makeFilterButtonAll(filter: String) -> some View {
        Button {
            print("I was tapped!")
            print(filter)
            viewModel.toggleTimeFilter(filterName: filter)
            print(viewModel.isFilteringActive)
        } label: {
            ZStack {
                if !viewModel.isTimeFilterSelected(filter) {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(lineWidth: 2)
                        .fill(.ypBlack)
                        .frame(width: 20, height: 20)
                }
                else {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.ypBlack)
                        .frame(width: 20, height: 20)
                    Image(systemName: "checkmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.ypWhite)
                        .frame(width: 12, height: 12)
                }
            }
        }
    .frame(width: 24, height: 24)
    }
    
    private func makeFilterButtonOne(filter: String) -> some View {
        Button {
            viewModel.changeTransitionFilter(filterName: filter)
        } label: {
            ZStack {
                if viewModel.isTransitionButtonActive(filterName: filter) {
                    Circle()
                        .stroke(lineWidth: 2)
                        .fill(.ypBlack)
                        .frame(width: 20, height: 20)
                    Circle()
                        .fill(.ypBlack)
                        .frame(width: 10, height: 10)
                }
                else {
                    Circle()
                        .stroke(lineWidth: 2)
                        .fill(.ypBlack)
                        .frame(width: 20, height: 20)
                }
            }
        }
        .frame(width: 24, height: 24)
    }
}

#Preview {
//    CarriersFilterSelectView(viewModel: CarriersFilterSelectViewModel())
}
