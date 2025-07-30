//
//  ScheduleSelectView.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/23/25.
//
import SwiftUI

struct ScheduleSettlementSelectView: View {
    private var elements: [String]
    
    @Environment(ErrorHandlerModel.self) var errorHandler: ErrorHandlerModel?
    @Environment(\.dismiss) private var dismiss

    @State private var filteredElements: [String] = []
    @State private var text: String = ""
    @State private var pickedCity: String?

    @State private var isScheduleStationSelectViewPresented: Bool = false
    @State private var isSearchBarFocused: Bool = false
    
    @Binding var isReturningToRoot: Bool
    @Bindable var model: ScheduleSettlementPickerModel
    
    
    init(model: ScheduleSettlementPickerModel, isSelfPresented: Binding<Bool>) {
        self.model = model
        self.elements = model.getCitiesString()
        self.filteredElements = elements
        
        _isReturningToRoot = isSelfPresented
    }
    
    var body: some View {
        if let error = errorHandler?.error {
            switch error {
            case .Internet:
                InternetErrorView()
                    .navigationTitle("Выбор города")
                    .navigationBarBackButtonHidden(true)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            CustomBackButton(action: {
                                dismiss()
                            })
                        }
                    }
            case .Server:
                ServerErrorView()
                    .navigationTitle("Выбор города")
                    .navigationBarBackButtonHidden(true)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            CustomBackButton(action: {
                                dismiss()
                            })
                        }
                    }
            }
        } else {
            VStack(spacing: 0) {
                CustomSearchBar(searchText: $text, isFocused: $isSearchBarFocused)
                    .navigationDestination(isPresented: $isScheduleStationSelectViewPresented) {
                        if let pickedCity {
                            ScheduleStationSelectView(model: model, pickedCity: pickedCity, isReturningToRoot: $isReturningToRoot)
                        }
                    }
                    .navigationTitle("Выбор города")
                    .navigationBarBackButtonHidden(true)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            CustomBackButton(action: {
                                dismiss()
                            })
                        }
                    }
                    .onChange(of: text) {
                        print(text)
                        filteredElements = text.isEmpty ? elements : elements.filter { $0.lowercased().contains(text.lowercased()) }
                    }
                Spacer(minLength: 0)
                Group {
                    if filteredElements.isEmpty {
                        ZStack {
                            Color(.ypWhite).ignoresSafeArea(edges: .all)
                            Text("Город не найден")
                                .font(FontStyleHelper.bold.getStyledFont(size: 24))
                        }
                    } else {
                        ScheduleSelectList(elements: filteredElements, actionOnSelected: scheduleSelectListButtonPressed)
                    }
                }
                .onTapGesture {
                    isSearchBarFocused = false
                }
                Spacer(minLength: 0)
            }
            .background(.ypWhite)
        }
    }
    
    func scheduleSelectListButtonPressed(pickedElement: String) {
        self.pickedCity = pickedElement
        isScheduleStationSelectViewPresented = true
        print(pickedElement)
    }
}

struct ScheduleSelectList: View {
    let elements: [String]
    var actionOnSelected: (_: String) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(elements, id: \.self) { element in
                    Button {
                        actionOnSelected(element)
                    } label: {
                        ScheduleSelectViewCell(cellName: element)
                    }
                }
            }
        }
    }
}

struct ScheduleSelectViewCell: View {
    let designedHeight: CGFloat = 60
    
    var cellName: String
    
    var body: some View {
        HStack {
            Text(cellName)
                .font(FontStyleHelper.regular.getStyledFont(size: 17))
                .tint(.ypBlack)
                .padding(.leading, 16)
            Spacer()
//            MARK: Мне интересно, в реальной разработке используются системные изображения или они заменяются копиями в ассетах (например из фигмы)?
            Image("ChevronForwardIcon")
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.ypBlack)
                .frame(width: 24, height: 24)
                .padding(.trailing, 18)
        }
        .frame(height: designedHeight)
    }
}
