//
//  ScheduleSettingsViewModel.swift
//  TravelSchedule
//
//  Created by Owi Lover on 8/17/25.
//

import SwiftUI

@MainActor
@Observable final class ScheduleSettingsViewModel: ScheduleSettingsViewModelProtocol {
    var isDarkTheme: Binding<Bool>
    
    var isUserAgreementPresented: Bool = false
    
    init(isDarkTheme: Binding<Bool>, isUserAgreementPresented: Bool = false) {
        self.isDarkTheme = isDarkTheme
        self.isUserAgreementPresented = isUserAgreementPresented
    }
    
    func presentUserAgreement() {
        isUserAgreementPresented = true
    }
}

@MainActor
protocol ScheduleSettingsViewModelProtocol {
    var isDarkTheme: Binding<Bool> { get set }
    
    var isUserAgreementPresented: Bool { get set }
    
    func presentUserAgreement()
}
