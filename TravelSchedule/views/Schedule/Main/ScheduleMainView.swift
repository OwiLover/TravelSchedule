//
//  ContentView.swift
//  TravelSchedule
//
//  Created by Owi Lover on 6/27/25.
//

import SwiftUI

struct ScheduleMainView: View {
    @Environment(ErrorHandlerModel.self) var errorHandlerModel: ErrorHandlerModel?
    
    @State private var viewModel: ScheduleMainViewModelProtocol
    
    init(viewModel: ScheduleMainViewModelProtocol = ScheduleMainViewModel()) {
        self.viewModel = viewModel
    }
    
    private var storiesPreviewFont: Font {
        FontStyleHelper.regular.getStyledFont(size: 12)
    }
    
    var body: some View {
        ErrorsHandlerView {
            mainView
        }
    }
    
    private var mainView: some View {
        NavigationStack {
            Group {
                VStack(spacing: 0) {
                    storiesView
                    ScheduleMainPicker
                        .padding(.top, 20)
                    Button {
                        viewModel.presentCarrierView()
                    }
                    label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ypBlueConstant)
                            Text("Найти")
                                .foregroundStyle(.ypWhiteConstant)
                                .font(FontStyleHelper.bold.getStyledFont(size: 17))
                        }
                        .frame(width: 150, height: 60)
                    }
                    .opacity(viewModel.checkSelection() ? 1 : 0)
                    .disabled(!viewModel.checkSelection())
                    .padding(.top, 16)
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $viewModel.isPresentedFromView) {
                ScheduleSettlementSelectView(isSelfPresented: $viewModel.isPresentedFromView, type: .from, settlementAndStation: $viewModel.selectedFrom)
            }
            
            .navigationDestination(isPresented: $viewModel.isPresentedToView) {
                ScheduleSettlementSelectView(isSelfPresented: $viewModel.isPresentedToView, type: .to, settlementAndStation: $viewModel.selectedTo)
            }
            .navigationDestination(isPresented: $viewModel.isPresentedCarrierView) {
                CarrierSelectView(settlementFrom: viewModel.selectedFrom, settlementTo: viewModel.selectedTo)
            }
            .background(Color.ypWhite)
            
            .fullScreenCover(isPresented: $viewModel.isStoryPresented) {
                ScheduleMainStoryView(selectedStory: viewModel.selectedStory)
            }
        }
    }
    
    var storiesView: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                ForEach(viewModel.storiesModel.stories) { story in
                    makeStoryView(story: story)
                        .onTapGesture {
                            viewModel.selectStory(story)
                        }
                }
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 16)
        }
    }
    
    var ScheduleMainPicker: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.ypBlueConstant)
                
                HStack(spacing: 16) {
                    VStack(spacing: 0) {
                        ScheduleMainPickerTextFieldButton(previewText: "Откуда", action: actionFrom, selectedText: $viewModel.selectionFromText)
                        ScheduleMainPickerTextFieldButton(previewText: "Куда", action: actionTo, selectedText: $viewModel.selectionToText)
                    }
                    .background(Color.ypWhiteConstant)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    Button {
                        viewModel.swapSettlements()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 40)
                                .fill(Color.ypWhiteConstant)
                                .frame(width: 36, height: 36)
                            Image("ChangeIcon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                        }
                    }
                }
                .padding(.all, 16)
            }
            .frame(height: 128)
            .padding(.horizontal, 16)
    }
    
    func makeStoryView(story: Story) -> some View {
        ZStack(alignment: .bottom) {
            story.previewImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(story.isWatched ? 0.5 : 1)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            Text(story.title)
                .font(storiesPreviewFont)
                .foregroundStyle(.ypWhiteConstant)
                .lineLimit(3)
                .padding(.bottom, 12)
                .padding(.horizontal, 8)
        }
        .frame(width: 92, height: 140)
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(lineWidth: 4)
                    .fill(.ypBlueConstant)
                    .opacity(story.isWatched ? 0 : 1)
            }
    }
    
    func actionFrom() {
        viewModel.isPresentedFromView = true
    }
    
    func actionTo() {
        viewModel.isPresentedToView = true
    }
}

struct ScheduleMainPickerTextFieldButton: View {
    let previewText: String
    var action: () -> Void
    @Binding var selectedText: String
    
    var body: some View {
        Button {
            action()
        } label: {
            TextField(text: $selectedText, label: {
                Text(previewText)
                    .foregroundStyle(.ypGrayConstant)
            })
            .foregroundStyle(.ypBlackConstant)
            
            .multilineTextAlignment(.leading)
                .disabled(true)
                .padding(.leading, 16)
                .padding(.vertical, 14)
        }
    }
}

#Preview {
    ScheduleMainView().onAppear {
//        testFetchScheduleSegment()
//        testFetchSchedule()
//        testFetchThreadStations()
//        testFetchNearestStations()
//        testFetchNearestCity()
//        testFetchCarriers()
//        testFetchStationsList()
//        testFetchCopyright()
    }
}
