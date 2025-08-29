//
//  SettingsView.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/31/25.
//

import SwiftUI

struct ScheduleSettingsView: View {
    
    @Environment(ErrorHandlerModel.self) var errorHandler: ErrorHandlerModel?
    
    @State private var viewModel: ScheduleSettingsViewModelProtocol
    
    init(isDarkTheme: Binding<Bool>) {
        self.viewModel = ScheduleSettingsViewModel(isDarkTheme: isDarkTheme)
    }
    
    init(viewModel: ScheduleSettingsViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    private var fontMain: Font {
        return FontStyleHelper.regular.getStyledFont(size: 17)
    }
    
    private var fontAdditionalInfo: Font {
        return FontStyleHelper.regular.getStyledFont(size: 12)
    }
    
    var body: some View {
        ErrorsHandlerView {
           settingsView
        }
    }
    
    private var settingsView: some View {
        NavigationStack {
            ZStack {
                Color.ypWhite
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    Toggle(isOn: viewModel.isDarkTheme) {
                        Text("Темная тема")
                            .font(fontMain)
                    }
                    .tint(.ypBlueConstant)
                    .frame(height: 60)
                    
                    Button {
                        viewModel.isUserAgreementPresented = true
                    } label: {
                        agreementButtonsLabel
                    }
                    .padding(.trailing, 2)
                    .frame(height: 60)
                    
                    Spacer()
                    appInfo
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 24)
            }
            .navigationDestination(isPresented: $viewModel.isUserAgreementPresented) {
                UserAgreementView()
            }
        }
    }
    
    private var agreementButtonsLabel: some View {
        HStack(spacing: 0) {
            Text("Пользовательское соглашение")
                .font(fontMain)
                .foregroundStyle(.ypBlack)
            Spacer()
            Image(.chevronForwardIcon)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.top, 3)
                .padding(.bottom, 2.18)
                .frame(width: 24, height: 24)
                .foregroundStyle(.ypBlack)
        }
    }
    
    private var appInfo: some View {
        VStack(spacing: 16) {
            Text("Приложение использует API «Яндекс.Расписания»")
                .font(fontAdditionalInfo)
            Text("Версия 1.0 (beta)")
                .font(fontAdditionalInfo)
        }
    }
}


#Preview {
    @Previewable @State var darkTheme = true
    ScheduleSettingsView(isDarkTheme: $darkTheme)
}
