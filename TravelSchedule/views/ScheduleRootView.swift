//
//  ScheduleTabBar.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/19/25.
//

import SwiftUI

struct ScheduleRootView: View {
    
    private enum SelectedTab: String {
        case Schedule
        case Settings
    }
    
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .ypWhite
                
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
//    @State private var errorHandler: ErrorHandlerModel = ErrorHandlerModel(error: .Server)
    @State private var errorHandler: ErrorHandlerModel = ErrorHandlerModel()
    
    @State private var selectedTab: SelectedTab = .Schedule
    
    @State private var pathHelper = CustomPathHelper()
    
    var body: some View {
//        MARK: Если не обернуть TabView в NavigationStack, то таббар появляется с задержкой при возврате после экрана выбора городов
        NavigationStack {
            TabView(selection: $selectedTab) {
                ScheduleMainView()
                    .tabItem {
                        Image(selectedTab == .Schedule ? "ScheduleTabBarIcon" : "ScheduleUnselectedTabBarIcon")
                    }
                    .tag(SelectedTab.Schedule)
                
                ScheduleSettingsView()
                    .tabItem {
                        Image(selectedTab == .Settings ? "SettingsTabBarIcon" : "SettingsUnselectedTabBarIcon")
                    }
                    .tag(SelectedTab.Settings)
            }
            .environment(pathHelper)
        }
        .environment(errorHandler)
    }
}
