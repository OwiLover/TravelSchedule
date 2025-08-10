//
//  ScheduleMainStoryView.swift
//  TravelSchedule
//
//  Created by Owi Lover on 8/9/25.
//

import SwiftUI
import Combine

struct ScheduleMainStoryView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var story: Story?
    
    private var currentStory: Image {
        guard let story else {
            return Image(systemName: "video.slash")
        }
        return story.storyImages[currentIndex]
    }
    
    @State private var currentProgress: Double = 0.0
    @State private var currentIndex = 0
    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 5/100, on: .main, in: .default)
    @State private var cancelable: Cancellable?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.ypBlackConstant
                    .ignoresSafeArea()
                currentStory
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 40))
                    .overlay {
                        storyUI
                    }
                    .padding(.top, 7)
                    .padding(.bottom, 17)
            }
            .onTapGesture { tap in
                if tap.x < geometry.size.width / 2 {
                   prevStory()
                } else {
                    nextStory()
                }
            }
        }
        .onAppear {
            resetTimer()
        }
        .onDisappear {
            cancelable?.cancel()
        }
        .onReceive(timer) { _ in
            increaseProgress()
        }
    }
    
    var storyUI: some View {
        ZStack {
            VStack {
                HStack {
                    ProgressBar(sectionsCount: story?.storyImages.count ?? 0, currentSection: currentIndex, progress: currentProgress)
                }
                .padding(.top, 28)
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
                
                backButton
                    .padding(.top, 4)
                    .padding(.horizontal, 12)
                Spacer()
                HStack(spacing: 0) {
                    StoryView(title: story?.title ?? "", text: story?.text ?? "")
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
            }
        }
    }
    
    var backButton: some View {
        HStack() {
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(.backButtonIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .frame(width: 32, height: 32)
        }
    }
    
    func nextStory() {
        if currentIndex < (story?.storyImages.count ?? 0) - 1 {
            currentIndex += 1
            resetTimer()
        } else {
            dismiss()
        }
    }
    
    func prevStory() {
        if currentIndex > 0 {
            currentIndex -= 1
        }
        resetTimer()
    }
    
    func resetTimer() {
        cancelable?.cancel()
        timer = Timer.publish(every: 5/100, on: .main, in: .default)
        cancelable = timer.connect()
        currentProgress = 0.0
    }
    
    func increaseProgress() {
        currentProgress += 0.01
        if currentProgress >= 1 {
            nextStory()
            currentProgress = 0
        }
    }
}

struct StoryView: View {
    var title: String
    
    var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(Font.system(size: 34, weight: .bold))
                .foregroundStyle(.ypWhiteConstant)
                .lineLimit(2)
            Text(text)
                .font(Font.system(size: 20, weight: .regular))
                .foregroundStyle(.ypWhiteConstant)
                .lineLimit(3)
        }
    }
}

#Preview {
    @Previewable @State var story = ScheduleStoriesModel().stories.first
    ScheduleMainStoryView(story: $story)
}
