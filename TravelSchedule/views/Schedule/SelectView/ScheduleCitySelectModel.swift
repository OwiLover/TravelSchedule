//
//  ScheduleCitySelectModel.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/26/25.
//

// MARK: bpyfxfkmyj

import SwiftUI

protocol ScheduleSettlementSelectViewProtocol: AnyObject, Observable{
    func getCitiesString() -> [String]
    func selectSettlement(withName: String)
}
