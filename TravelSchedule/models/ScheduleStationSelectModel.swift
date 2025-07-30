//
//  ScheduleStationSelectModel.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/26/25.
//

import SwiftUI

protocol ScheduleStationSelectViewProtocol: AnyObject, Observable {
    func getStationsString(for city: String) -> [String]
    func selectStation(withName: String)
}
