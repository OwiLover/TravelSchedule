//
//  FontStyleHelper.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/18/25.
//

import SwiftUI

enum FontStyleHelper: String {
    case regular
    case bold
    
    func getStyledFont(size: CGFloat) -> Font {
        switch self {
        case .regular:
            return Font.system(size: size, weight: .regular)
        case .bold:
            return Font.system(size: size, weight: .bold)
        }
    }
}

