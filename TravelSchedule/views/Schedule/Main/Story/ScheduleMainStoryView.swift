//
//  ScheduleMainStoryView.swift
//  TravelSchedule
//
//  Created by Owi Lover on 8/9/25.
//

import SwiftUI

struct ScheduleMainStoryView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var viewModel: ScheduleMainStoryViewModel
    
    init(viewModel: ScheduleMainStoryViewModel? = nil, selectedStory: Story?) {
        self.viewModel = viewModel ?? ScheduleMainStoryViewModel(story: selectedStory)
    }
    
    private var currentStory: Image {
        viewModel.storyImage
    }
    
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
                    viewModel.prevStory()
                } else {
                    viewModel.nextStory()
                }
            }
        }
        .onAppear {
            viewModel.dismissAction = dismissAction
            viewModel.resetTimer()
        }
        .onDisappear {
            viewModel.cancelTimer()
        }
    }
    
    var storyUI: some View {
        ZStack {
            VStack {
                HStack {
                    ProgressBar(sectionsCount: viewModel.getStoriesCount(), currentSection: viewModel.currentIndex, progress: viewModel.currentProgress)
                }
                .padding(.top, 28)
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
                
                backButton
                    .padding(.top, 4)
                    .padding(.horizontal, 12)
                Spacer()
                HStack(spacing: 0) {
                    StoryView(title: viewModel.getStoryTitle(), text: viewModel.getStoryText())
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
    
    func dismissAction() {
        dismiss()
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
//    ScheduleMainStoryView(story: $story)
}
