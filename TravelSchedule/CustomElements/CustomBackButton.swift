//
//  CustomBackButton.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/28/25.
//
import SwiftUI

struct CustomBackButton: View {
    var action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            Image("ChevronBackwardIcon")
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.ypBlack)
                .frame(width: 17, height: 22)
        }
        .foregroundStyle(.ypBlack)
    }
}
