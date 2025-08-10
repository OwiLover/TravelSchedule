//
//  CarriersFilterSelectView.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/29/25.
//

import SwiftUI

// MARK: Несмотря на то, что фильтр пересадок в макете изначально не имеет никакого значения, посчитал это нелогичным, поскольку фильтр не может быть не иметь одно из значений и выставил базовое значение на "Да"

struct CarriersFilterSelectView: View {
    
    @Environment(ErrorHandlerModel.self) var errorHandler: ErrorHandlerModel?
    
    @Bindable var model: CarriersFilterSelectModel
    
    @Environment(\.dismiss) private var dismiss
    
    private let sectionFont = FontStyleHelper.bold.getStyledFont(size: 24)
    
    private let optionsFont = FontStyleHelper.regular.getStyledFont(size: 17)
    
    var body: some View {
        if let error = errorHandler?.error {
            switch error {
            case .Internet:
                InternetErrorView()
            case .Server:
                ServerErrorView()
            }
        } else {
            ZStack(alignment: .bottom) {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        makeSectionList(info: model.getTimeFiltersInfo())
                        makeSectionList(info: model.getTransitionFilterInfo())
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
            model.toggleFilter(filterName: filter)
            print(model.isFilteringActive)
        } label: {
            ZStack {
                if !model.isFilterSelected(filter) {
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
            model.changeTransitionFilter(filterName: filter)
        } label: {
            ZStack {
                if model.isTransitionButtonActive(filterName: filter) {
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
    CarriersFilterSelectView(model: CarriersFilterSelectModel())
}
