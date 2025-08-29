//
//  ScheduleTabBar.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/19/25.
//

import SwiftUI

struct ScheduleRootView: View {
    
    @State private var viewModel: ScheduleRootViewModelProtocol
    
    init(viewModel: ScheduleRootViewModelProtocol = ScheduleRootViewModel()) {
        self.viewModel = viewModel
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .ypWhite
                
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $viewModel.selectedTab) {
                ScheduleMainView()
                    .tabItem {
                        Image(viewModel.selectedTab == .Schedule ? "ScheduleTabBarIcon" : "ScheduleUnselectedTabBarIcon")
                    }
                    .tag(SelectedTab.Schedule)
                
                ScheduleSettingsView(isDarkTheme: $viewModel.isDarkTheme)
                    .tabItem {
                        Image(viewModel.selectedTab == .Settings ? "SettingsTabBarIcon" : "SettingsUnselectedTabBarIcon")
                    }
                    .tag(SelectedTab.Settings)
            }
        }
        .environment(viewModel.errorHandler)
        .preferredColorScheme(viewModel.isDarkTheme ? .dark : .light)
    }
}
