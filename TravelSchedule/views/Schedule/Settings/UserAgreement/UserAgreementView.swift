//
//  UserAgreementView.swift
//  TravelSchedule
//
//  Created by Owi Lover on 8/7/25.
//

import SwiftUI

struct UserAgreementView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    private let viewModel: UserAgreementViewModelProtocol
    
    init(viewModel: UserAgreementViewModelProtocol = UserAgreementViewModel()) {
        self.viewModel = viewModel
    }
    
    private let fontHeader: Font = FontStyleHelper.bold.getStyledFont(size: 24)
    private let fontText: Font = FontStyleHelper.regular.getStyledFont(size: 17)
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                ForEach(viewModel.getElements(), id: \.header) { element in
                    createTextBlock(header: element.header, text: element.text)
                }
            }
            .padding(.all, 16)
        }
        .navigationTitle("Пользовательское соглашение")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CustomBackButton(action: {
                    dismiss()
                })
            }
        }
        .background(.ypWhite)
    }
    
    func createTextBlock(header: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(header)
                .font(fontHeader)
            Text(text)
                .font(fontText)
        }
    }
}

#Preview {
    UserAgreementView()
}
