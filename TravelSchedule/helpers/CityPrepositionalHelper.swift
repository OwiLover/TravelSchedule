//
//  CityPrepositionalHelper.swift
//  TravelSchedule
//
//  Created by Owi Lover on 8/27/25.
//

import Foundation

struct CityPrepositionalHelper: Sendable {
    static func toPrepositional(_ city: String) -> String {
        var prepCity = city
        if prepCity.hasSuffix("а") || prepCity.hasSuffix("я") {
            prepCity.removeLast()
            prepCity += "е"
            
        } else if prepCity.hasSuffix("ь") {
            prepCity.removeLast()
            prepCity += "и"
            
        } else if prepCity.hasSuffix("й") {
            prepCity.removeLast()
            prepCity += "е"
            
        } else if prepCity.hasSuffix("и") || prepCity.hasSuffix("о") || prepCity.hasSuffix("е") || prepCity.hasSuffix("у") {
            // Оставляем как есть
        } else {
            prepCity += "е"
        }
        
        return prepCity
    }
}
