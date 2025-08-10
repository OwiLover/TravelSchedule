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
//    @State private var errorHandler: ErrorHandlerModel = ErrorHandlerModel(error: .Internet)
    @State private var errorHandler: ErrorHandlerModel = ErrorHandlerModel()
    
    @State private var selectedTab: SelectedTab = .Schedule
    
    @State private var pathHelper = CustomPathHelper()
    
    @State private var isDarkTheme: Bool = false
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                ScheduleMainView()
                    .tabItem {
                        Image(selectedTab == .Schedule ? "ScheduleTabBarIcon" : "ScheduleUnselectedTabBarIcon")
                    }
                    .tag(SelectedTab.Schedule)
                
                ScheduleSettingsView(isDarkTheme: $isDarkTheme)
                    .tabItem {
                        Image(selectedTab == .Settings ? "SettingsTabBarIcon" : "SettingsUnselectedTabBarIcon")
                    }
                    .tag(SelectedTab.Settings)
            }
            .environment(pathHelper)
        }
        .environment(errorHandler)
        .preferredColorScheme(isDarkTheme ? .dark : .light)
    }
}
