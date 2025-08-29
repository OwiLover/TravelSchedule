//
//  ScheduleMainStoryViewModel.swift
//  TravelSchedule
//
//  Created by Owi Lover on 8/18/25.
//

import SwiftUI
import Combine

@MainActor
@Observable final class ScheduleMainStoryViewModel: ScheduleMainStoryViewModelProtocol {
    
    private var story: Story?
    
    private(set) var currentProgress: Double = 0.0
    private(set) var currentIndex = 0
    private var timer: Timer.TimerPublisher = Timer.publish(every: 5/100, on: .main, in: .default)
    private var cancelable: Cancellable?
    
    private var timerSubscriber: AnyCancellable?
    
    var dismissAction: () -> Void = { }
    
    init(story: Story? = nil) {
        self.story = story
        self.timerSubscriber = timer.sink { [weak self] _ in
            self?.increaseProgress()
        }
    }
    
    var storyImage: Image {
        guard let story else {
            return Image(systemName: "video.slash")
        }
        return story.storyImages[currentIndex]
    }
    
    func nextStory() {
        if currentIndex < (story?.storyImages.count ?? 0) - 1 {
            currentIndex += 1
            resetTimer()
        } else {
            dismissAction()
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
        self.timerSubscriber = timer.sink {[weak self] _ in  self?.increaseProgress() }
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
    
    func cancelTimer() {
        cancelable?.cancel()
    }
    
    func getStoryTitle() -> String {
        story?.title ?? ""
    }
    
    func getStoryText() -> String {
        story?.text ?? ""
    }
    
    func getStoriesCount() -> Int {
        story?.storyImages.count ?? 0
    }
}

@MainActor
protocol ScheduleMainStoryViewModelProtocol {
    var currentProgress: Double { get }
    var currentIndex: Int { get }
    
}
