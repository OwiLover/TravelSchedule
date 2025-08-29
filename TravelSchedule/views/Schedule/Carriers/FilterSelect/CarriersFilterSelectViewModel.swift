//
//  CarriersFilterSelectModel.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/29/25.
//

import SwiftUI

enum FilterType: Int {
    case all = 0
    case one
}

enum FilterOption: String, CaseIterable {
    case morning = "Утро 06:00 - 12:00"
    case day = "День 12:00 - 18:00"
    case evening = "Вечер 18:00 - 00:00"
    case night = "Ночь 00:00 - 06:00"
    
    func isIncluded(time: String) -> Bool {
        
        guard let hourString = time.split(separator: ":").first, let hour = Int(hourString) else { return false }
        
        switch self {
        case .morning:
            return intervalCheck(hour: hour, from: 6, to: 12)
        case .day:
            return intervalCheck(hour: hour, from: 12, to: 18)
        case .evening:
            return intervalCheck(hour: hour, from: 18, to: 24)
        case .night:
            return intervalCheck(hour: hour, from: 0, to: 6)
        }
    }
    
    private func intervalCheck(hour: Int, from: Int, to: Int) -> Bool {
        guard hour >= from, hour < to else { return false }
        return true
    }
}

struct FilterInfo: Sendable {
    var sectionName: String
    var filters: [String]
    var isOnlyOneAllowed: Bool
}

enum TransitionFilterOption: String, CaseIterable {
    case yes = "Да"
    case no = "Нет"
}

@MainActor
@Observable final class CarriersFilterSelectViewModel: CarrierFilterSelectViewModelProtocol {

    private var filters: CarrierFilters
    
    init(carrierFilters: CarrierFilters) {
        self.filters = carrierFilters
    }
    
    var isFilteringActive: Bool {
        filters.isFilteringActive()
    }
    
    func getTimeFiltersInfo() -> FilterInfo {
        return FilterInfo(sectionName: "Время отправления", filters: FilterOption.allCases.map(\.rawValue), isOnlyOneAllowed: false)
    }
    
    func getTransitionFilterInfo() -> FilterInfo {
        return FilterInfo(sectionName: "Показывать варианты с пересадками", filters: TransitionFilterOption.allCases.map(\.rawValue), isOnlyOneAllowed: true)
    }
    
    func changeTransitionFilter(filterName: String) {
        guard let filterOption = TransitionFilterOption(rawValue: filterName) else { return }
        print("Entering transitionFilter \(filterOption)")
        switch filterOption {
        case .yes:
            filters.allowTransitionFilter = true
        case .no:
            filters.allowTransitionFilter = false
        }
    }
    
    func isTransitionButtonActive(filterName: String) -> Bool {
        guard let filterOption = TransitionFilterOption(rawValue: filterName) else { return false }
        
        return (filterOption == .yes && filters.allowTransitionFilter) || (filterOption == .no && !filters.allowTransitionFilter) ? true : false
    }
    
    func addTimeFilter(filterName: String) {
        guard let filterOption = FilterOption(rawValue: filterName) else { return }
        filters.selectedTimeFilters.insert(filterOption)
    }
    
    func removeTimeFilter(filterName: String) {
        guard let filterOption = FilterOption(rawValue: filterName) else { return }
        filters.selectedTimeFilters.remove(filterOption)
    }
    
    func toggleTimeFilter(filterName: String) {
        print("Entering...")
        guard let filterOption = FilterOption(rawValue: filterName) else {
            print("Whoops, can't find filter!")
            return }
        print("Yay, \(filters.selectedTimeFilters)")
        if filters.selectedTimeFilters.contains(filterOption) {
            filters.selectedTimeFilters.remove(filterOption)
        } else {
            filters.selectedTimeFilters.insert(filterOption)
        }
    }
    
    func isTimeFilterSelected(_ filterName: String) -> Bool {
        guard let filterOption = FilterOption(rawValue: filterName) else { return false }
        return filters.selectedTimeFilters.contains(filterOption)
    }
}

@MainActor
protocol CarrierFilterSelectViewModelProtocol {
    var isFilteringActive: Bool { get }
    func getTimeFiltersInfo() -> FilterInfo
    func getTransitionFilterInfo() -> FilterInfo
    func changeTransitionFilter(filterName: String)
    func isTransitionButtonActive(filterName: String) -> Bool
    func addTimeFilter(filterName: String)
    func removeTimeFilter(filterName: String)
    func toggleTimeFilter(filterName: String)
    func isTimeFilterSelected(_ filterName: String) -> Bool
}
