//
//  CustomPathHelper.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/27/25.
//
import SwiftUI

// MARK: Попытка использовать NavigationPath, однако из-за нехватки времени остались только наработки

@Observable final class CustomPathHelper: Identifiable {
    var path: [String]
    
    init(path: [String] = []) {
        self.path = path
    }
    
    func addView(withId viewId: String) {
        path.append(viewId)
    }
    
    func dismissAll() {
        path.removeAll()
    }
}
