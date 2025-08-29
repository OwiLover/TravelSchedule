//
//  ScheduleSelectView.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/23/25.
//
import SwiftUI

struct ScheduleSettlementSelectView: View {
    
    @Environment(ErrorHandlerModel.self) var errorHandler: ErrorHandlerModel?
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: ScheduleSettlementSelectViewModelProtocol
    
    private let fontForLoading: Font = FontStyleHelper.regular.getStyledFont(size: 17)
    
    init(isSelfPresented: Binding<Bool>, type: SelectionType, settlementAndStation: Binding<SettlementAndStation>?) {
            self.viewModel = ScheduleSettlementSelectViewModel(isViewPresented: isSelfPresented, type: type, settlementAndStation: settlementAndStation)
    }
    
    var body: some View {
        ErrorsHandlerView {
            ZStack {
                mainView
                    .disabled(viewModel.isLoading)
                    .opacity(viewModel.isLoading ? 0 : 1)
                VStack {
                    Text("Города загружаются, подождите...")
                        .font(fontForLoading)
                        .foregroundStyle(.ypBlack)
                    ProgressView()
                }
                .opacity(viewModel.isLoading ? 1 : 0)
            }
        }
        .background(.ypWhite)
        .navigationDestination(isPresented: $viewModel.isScheduleStationSelectViewPresented) {
            if let pickedCity = viewModel.pickedCity {
                ScheduleStationSelectView(pickedCity: pickedCity, isViewStackPresented: viewModel.isViewPresented, settlementAndStation: viewModel.settlementAndStation)
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
        .onChange(of: viewModel.text) {
            viewModel.updateFilteredElements()
        }
        .task {
            Task {
                await viewModel.loadElements()
            }
        }
    }
    
    private var mainView: some View {
        VStack(spacing: 0) {
            CustomSearchBar(searchText: $viewModel.text, isFocused: $viewModel.isSearchBarFocused)
            Spacer(minLength: 0)
            Group {
                ZStack {
                    ScheduleSelectList(elements: viewModel.filteredElements, actionOnSelected: scheduleSelectListButtonPressed)
                        .opacity(viewModel.isEmpty() ? 0 : 1)
                        .disabled(viewModel.isEmpty())
                    VStack {
                        Text("Город не найден")
                            .font(FontStyleHelper.bold.getStyledFont(size: 24))
                    }
                    .background(.ypWhite)
                    .ignoresSafeArea()
                    .opacity(viewModel.isEmpty() ? 1 : 0)
                }
            }
            .onTapGesture {
                viewModel.isSearchBarFocused = false
            }
            Spacer(minLength: 0)
        }
    }
    
    func scheduleSelectListButtonPressed(pickedElement: String) {
        viewModel.presentScheduleStationSelectView(withPickedCity: pickedElement)
    }
}

struct ScheduleSelectList: View {
    let elements: [any CellItemProtocol]
    var actionOnSelected: (_: String) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(elements, id: \.id) { element in
                    Button {
                        actionOnSelected(element.fullName)
                    } label: {
                        ScheduleSelectViewCell(cellName: element.name)
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
