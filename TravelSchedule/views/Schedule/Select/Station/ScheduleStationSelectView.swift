//
//  ScheduleStationSelectView.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/25/25.
//

import SwiftUI

struct ScheduleStationSelectView: View {
    
    @Environment(ErrorHandlerModel.self) var errorHandler: ErrorHandlerModel?
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel: ScheduleStationSelectViewModelProtocol

    init(pickedCity: String, isViewStackPresented: Binding<Bool>, type: SelectionType, settlementAndStation: Binding<SettlementAndStation>?, viewModel: ScheduleStationSelectViewModelProtocol? = nil) {
        self.viewModel = viewModel ?? ScheduleStationSelectViewModel(isViewStackPresented: isViewStackPresented, pickedSettlement: pickedCity, type: type, settlementAndStation: settlementAndStation)
    }
    
    var body: some View {
        ErrorsHandlerView {
            mainView
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Выбор станции")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CustomBackButton(action: {
                    dismiss()
                })
            }
        }
        .task {
            await viewModel.loadElements()
        }
    }
    
    var mainView: some View {
        VStack(spacing: 0) {
            CustomSearchBar(searchText: $viewModel.text, isFocused: $viewModel.isSearchBarFocused)
            Spacer(minLength: 0)
            Group {
                if viewModel.filteredElements.isEmpty {
                    ZStack {
                        Text("Станция не найдена")
                            .font(FontStyleHelper.bold.getStyledFont(size: 24))
                    }
                } else {
                    ScheduleSelectList(elements: viewModel.filteredElements, actionOnSelected: scheduleSelectListButtonPressed)
                }
            }
            .onTapGesture {
                viewModel.isSearchBarFocused = false
            }
            .onChange(of: viewModel.text) {
                viewModel.updateFilteredElements()
            }
            Spacer(minLength: 0)
        }
        .background(Color.ypWhite)
    }
    
    func scheduleSelectListButtonPressed(pickedElement: String) {
        Task {
            await viewModel.makeSelectionAndReturnToRootView(pickedStation: pickedElement)
        }
    }
}
