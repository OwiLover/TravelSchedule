//
//  ProgressBar.swift
//  TravelSchedule
//
//  Created by Owi Lover on 8/9/25.
//

import SwiftUI

struct ProgressBarPart: View {
    var readyPercent: Double = 0.0
    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.white)
                .overlay(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.blue)
                        .frame(width: min(geometry.size.width, geometry.size.width * CGFloat(readyPercent)))
    
                }
                .onAppear {
                    print(geometry.size)
                }
        }.frame(height: 6)
    }
    
    func setHeight(height: CGFloat) {
        print("setHeight: \(height)")
    }
}

struct ProgressBar: View {
    var sectionsCount: Int
    var currentSection: Int
    var progress: Double = 0.0
    var body: some View {
        HStack {
            ForEach(0..<sectionsCount, id: \.self) { counter in
                if currentSection > counter {
                    ProgressBarPart(readyPercent: 1)
                } else if currentSection == counter {
                    ProgressBarPart(readyPercent: progress)
                } else {
                    ProgressBarPart(readyPercent: 0)
                }
            }
        }
    }
}

#Preview {
    Color.ypBlack
        .ignoresSafeArea()
        .overlay(
            HStack {
                ProgressBar(sectionsCount: 4, currentSection: 0, progress: 0.1)
            }.padding()
        )
}
