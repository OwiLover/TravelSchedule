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
    
    @State var isPresentedFromView: Bool = false
    @State var isPresentedToView: Bool = false
    @State var isPresentedCarrierView: Bool = false
    
    var body: some View {
        if let error = errorHandlerModel?.error {
            switch error {
            case .Internet:
                InternetErrorView()
            case .Server:
                ServerErrorView()
            }
        } else {
            NavigationStack {
                Group {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: 188)
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
            }
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
