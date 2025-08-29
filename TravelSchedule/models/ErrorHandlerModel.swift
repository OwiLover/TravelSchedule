//
//  ErrorHandlerModel.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/31/25.
//

import SwiftUI

enum Errors: String {
    case Internet
    case Server
}

@Observable final class ErrorHandlerModel {
    var error: Errors?
    
    init(error: Errors? = nil) {
        self.error = error
    }
}
