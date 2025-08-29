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
}

struct FilterInfo {
    var sectionName: String
    var filters: [String]
    var isOnlyOneAllowed: Bool
}

enum TransitionFilterOption: String, CaseIterable {
    case yes = "Да"
    case no = "Нет"
}

@Observable final class CarriersFilterSelectModel {

    var selectedTimeFilters: Set<FilterOption> = []
    var allowTransitionFilter: Bool = true
    
    var isFilteringActive: Bool {
        return !selectedTimeFilters.isEmpty || !allowTransitionFilter
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
            allowTransitionFilter = true
        case .no:
            allowTransitionFilter = false
        }
    }
    
    func isTransitionButtonActive(filterName: String) -> Bool {
        guard let filterOption = TransitionFilterOption(rawValue: filterName) else { return false }
        
        return (filterOption == .yes && allowTransitionFilter) || (filterOption == .no && !allowTransitionFilter) ? true : false
    }
    
    func addFilter(filterName: String) {
        guard let filterOption = FilterOption(rawValue: filterName) else { return }
        selectedTimeFilters.insert(filterOption)
    }
    func removeFilter(filterName: String) {
        guard let filterOption = FilterOption(rawValue: filterName) else { return }
        selectedTimeFilters.remove(filterOption)
    }
    
    func toggleFilter(filterName: String) {
        print("Entering...")
        guard let filterOption = FilterOption(rawValue: filterName) else {
            print("Whoops, can't find filter!")
            return }
        print("Yay, \(selectedTimeFilters)")
        if selectedTimeFilters.contains(filterOption) {
            selectedTimeFilters.remove(filterOption)
        } else {
            selectedTimeFilters.insert(filterOption)
        }
    }
    
    func isFilterSelected(_ filterName: String) -> Bool {
        guard let filterOption = FilterOption(rawValue: filterName) else { return false }
        return selectedTimeFilters.contains(filterOption)
    }
}
