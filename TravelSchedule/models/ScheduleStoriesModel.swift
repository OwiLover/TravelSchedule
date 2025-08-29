//
//  ScheduleStoriesModel.swift
//  TravelSchedule
//
//  Created by Owi Lover on 8/8/25.
//
import SwiftUI

@Observable final class ScheduleStoriesModel {
    init() {
        
    }
    var stories: [Story] = [
        Story(previewImage: .init(.storyPreview1), storyImages: [.init(.storyFirstBig1), .init(.storySecondBig1)]),
        Story(previewImage: .init(.storyPreview2), storyImages: [.init(.storyFirstBig2), .init(.storySecondBig2)]),
        Story(previewImage: .init(.storyPreview3), storyImages: [.init(.storyFirstBig3), .init(.storySecondBig3)]),
        Story(previewImage: .init(.storyPreview4), storyImages: [.init(.storyFirstBig4), .init(.storySecondBig4)]),
        Story(previewImage: .init(.storyPreview5), storyImages: [.init(.storyFirstBig5), .init(.storySecondBig5)]),
        Story(previewImage: .init(.storyPreview6), storyImages: [.init(.storyFirstBig6), .init(.storySecondBig6)]),
        Story(previewImage: .init(.storyPreview7), storyImages: [.init(.storyFirstBig7), .init(.storySecondBig7)]),
        Story(previewImage: .init(.storyPreview8), storyImages: [.init(.storyFirstBig8), .init(.storySecondBig8)]),
        Story(previewImage: .init(.storyPreview9), storyImages: [.init(.storyFirstBig9), .init(.storySecondBig9)])
    ]
    
    func setStoryWatched(story: Story) {
        stories.first(where: { $0.id == story.id })?.isWatched = true
    }
}

@Observable final class Story: Identifiable {
    init(previewImage: Image, storyImages: [Image], isWatched: Bool = false) {
        self.id = UUID()
        self.previewImage = previewImage
        self.storyImages = storyImages
        self.isWatched = isWatched
    }
    var id: UUID = UUID()
    var previewImage: Image
    var title: String = "Text Text Text Text Text Text Text Text Text Text"
    var text: String = "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text"
    var storyImages: [Image]
    var isWatched: Bool = false
}
