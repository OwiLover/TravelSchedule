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
    
    @Bindable var model: ScheduleSettlementPickerModel
    @Binding var isReturningToRoot: Bool
    
    @State private var filteredElements: [String] = []
    @State private var text: String = ""
    @State private var isSearchBarFocused: Bool = false
    
    private let pickedCity: String
    
    private var elements: [String]
    
    init(model: ScheduleSettlementPickerModel, pickedCity: String, isReturningToRoot: Binding<Bool>) {
        self.model = model
        self.pickedCity = pickedCity
        self.elements = model.getStationsString(for: pickedCity)
        _isReturningToRoot = isReturningToRoot
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
        .onAppear {
            filteredElements = elements
        }
    }
    
    var mainView: some View {
        VStack(spacing: 0) {
            CustomSearchBar(searchText: $text, isFocused: $isSearchBarFocused)
            Spacer(minLength: 0)
            Group {
                if filteredElements.isEmpty {
                    ZStack {
                        Text("Станция не найдена")
                            .font(FontStyleHelper.bold.getStyledFont(size: 24))
                    }
                } else {
                    ScheduleSelectList(elements: filteredElements, actionOnSelected: scheduleSelectListButtonPressed)
                }
            }
            .onTapGesture {
                isSearchBarFocused = false
            }
            .onChange(of: text) {
                filteredElements = text.isEmpty ? elements : elements.filter { $0.lowercased().contains(text.lowercased()) }
            }
            Spacer(minLength: 0)
        }
        .background(Color.ypWhite)
    }
    
    func scheduleSelectListButtonPressed(pickedElement: String) {
        model.makeSelection(settlement: pickedCity, station: pickedElement)
        isReturningToRoot = false
    }
}
