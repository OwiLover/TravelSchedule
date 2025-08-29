//
//  ScheduleRootViewModel.swift
//  TravelSchedule
//
//  Created by Owi Lover on 8/17/25.
//

import SwiftUI

enum SelectedTab: String {
    case Schedule
    case Settings
}

@MainActor
@Observable final class ScheduleRootViewModel: ScheduleRootViewModelProtocol {
    var errorHandler: ErrorHandlerModel = ErrorHandlerModel()
    
    var selectedTab: SelectedTab = .Schedule
    
    var isDarkTheme: Bool = false
}

@MainActor
protocol ScheduleRootViewModelProtocol {
    var errorHandler: ErrorHandlerModel { get set }
    
    var selectedTab: SelectedTab { get set }
    
    var isDarkTheme: Bool { get set }
}
