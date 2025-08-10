//
//  InternetErrorView.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/30/25.
//

import SwiftUI

struct InternetErrorView: View {
    private let errorTextFont: Font = FontStyleHelper.bold.getStyledFont(size: 24)
    
    var body: some View {
        ZStack {
            Color(.ypWhite)
                .ignoresSafeArea(edges: .all)
            VStack(spacing: 16) {
                Image("InternetErrorImage")
                Text("Нет интернета")
                    .font(errorTextFont)
            }
        }
    }
}

#Preview {
    InternetErrorView()
}
