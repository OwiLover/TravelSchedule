//
//  ContentView.swift
//  TravelSchedule
//
//  Created by Owi Lover on 6/27/25.
//

import SwiftUI

struct ScheduleMainView: View {
    @Environment(ErrorHandlerModel.self) var errorHandlerModel: ErrorHandlerModel?
    
    @State var fromModel = ScheduleSettlementPickerModel()
    @State var toModel = ScheduleSettlementPickerModel()
    @State var storiesModel = ScheduleStoriesModel()
    
    @State var isPresentedFromView: Bool = false
    @State var isPresentedToView: Bool = false
    @State var isPresentedCarrierView: Bool = false
    @State var isStoryPresented: Bool = false
    
    @State var selectedStory: Story? = nil
    
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
//                        .frame(height: 188)
                    ScheduleMainPicker(modelFrom: fromModel, modelTo: toModel, actionFrom: actionFrom, actionTo: actionTo)
                        .padding(.top, 20)
                    Button {
                        isPresentedCarrierView = true
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
                    .opacity(checkModelsSelection() ? 1 : 0)
                    .disabled(checkModelsSelection() ? false : true)
                    .padding(.top, 16)
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $isPresentedFromView) {
                ScheduleSettlementSelectView(model: fromModel, isSelfPresented: $isPresentedFromView)
            }
            
            .navigationDestination(isPresented: $isPresentedToView) {
                ScheduleSettlementSelectView(model: toModel, isSelfPresented: $isPresentedToView)
            }
            .navigationDestination(isPresented: $isPresentedCarrierView) {
                CarrierSelectView(fromModel: fromModel, toModel: toModel)
            }
            .background(Color.ypWhite)
            
            .fullScreenCover(isPresented: $isStoryPresented) {
                ScheduleMainStoryView(story: $selectedStory)
            }
        }
    }
    
    var storiesView: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                ForEach(storiesModel.stories) { story in
                    makeStoryView(story: story)
                        .onTapGesture {
                            story.isWatched = true
                            selectedStory = story
                            isStoryPresented = true
                        }
                }
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 16)
        }
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
        isPresentedFromView = true
    }
    
    func actionTo() {
        isPresentedToView = true
    }
    
    func checkModelsSelection() -> Bool {
        toModel.checkIfAllSelected() && fromModel.checkIfAllSelected()
    }
}

struct ScheduleMainPicker: View {
    @Bindable var modelFrom: ScheduleSettlementPickerModel
    @Bindable var modelTo: ScheduleSettlementPickerModel
    
    var actionFrom: () -> Void
    var actionTo: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.ypBlueConstant)
            
            HStack(spacing: 16) {
                VStack(spacing: 0) {
                    ScheduleMainPickerTextFieldButton(previewText: "Откуда", action: actionFrom, selectedText: $modelFrom.selectionText)
                    ScheduleMainPickerTextFieldButton(previewText: "Куда", action: actionTo, selectedText: $modelTo.selectionText)
                }
                .background(Color.ypWhiteConstant)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Button {
                    modelTo.swapSettlements(with: modelFrom)
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
