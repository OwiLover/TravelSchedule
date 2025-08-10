//
//  SettingsView.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/31/25.
//

import SwiftUI

struct ScheduleSettingsView: View {
    
    @Environment(ErrorHandlerModel.self) var errorHandler: ErrorHandlerModel?
    
    @Binding var isDarkTheme: Bool
    
    @State var isUserAgreementPresented: Bool = false
    
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
                    Toggle(isOn: $isDarkTheme) {
                        Text("Темная тема")
                            .font(fontMain)
                    }
                    .tint(.ypBlueConstant)
                    .frame(height: 60)
                    
                    Button {
                        isUserAgreementPresented = true
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
            .navigationDestination(isPresented: $isUserAgreementPresented) {
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
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.top, 3)
                .padding(.bottom, 2.18)
                .frame(width: 24, height: 24)
                .foregroundColor(.ypBlack)
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
