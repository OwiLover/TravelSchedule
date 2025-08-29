//
//  Image+DataExtension.swift
//  TravelSchedule
//
//  Created by Owi Lover on 8/27/25.
//

import SwiftUI
import UIKit

extension Image {
    init(data: Data?) {
        if let data, let image = UIImage(data: data) {
            self.init(uiImage: image)
        } else {
            self.init(systemName: "square.slash")
        }
    }
}
