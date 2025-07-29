//
//  ScheduleStationSelectView.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/25/25.
//

import SwiftUI

struct ScheduleStationSelectView: View {
    
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
            Group {
                CustomSearchBar(searchText: $text, isFocused: $isSearchBarFocused)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            CustomBackButton(action: {
                                dismiss()
                            })
                    }
                Group {
                    if filteredElements.isEmpty {
                        ZStack {
                            Color(.ypWhite).ignoresSafeArea(edges: .all)
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
            }
            .background(Color.ypWhite)
            .onChange(of: text) {
                filteredElements = text.isEmpty ? elements : elements.filter { $0.lowercased().contains(text.lowercased()) }
            }
            .onAppear {
                filteredElements = elements
            }
            .navigationTitle("Выбор станции")
            .navigationBarBackButtonHidden(true)
        }
    }
    
    func scheduleSelectListButtonPressed(pickedElement: String) {
        model.makeSelection(settlement: pickedCity, station: pickedElement)
        isReturningToRoot = false
    }
}
