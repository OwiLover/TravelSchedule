//
//  UserAgreementView.swift
//  TravelSchedule
//
//  Created by Owi Lover on 8/7/25.
//

import SwiftUI

struct UserAgreementView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    private var elements: [(header: String, text: String)] = [("""
Оферта на оказание образовательных услуг дополнительного образования Яндекс.Практикум  для физических лиц
""",
"""
Данный документ является действующим, если расположен по адресу: https://yandex.ru/legal/practicum_offer
                                                               
Российская Федерация, город Москва
"""),
    ("1. ТЕРМИНЫ",
    """
        Понятия, используемые в Оферте, означают следующее:  Авторизованные адреса — адреса электронной почты каждой Стороны. Авторизованным адресом Исполнителя является адрес электронной почты, указанный в разделе 11 Оферты. Авторизованным адресом Студента является адрес электронной почты, указанный Студентом в Личном кабинете.  Вводный курс — начальный Курс обучения по представленным на Сервисе Программам обучения в рамках выбранной Студентом Профессии или Курсу, рассчитанный на определенное количество часов самостоятельного обучения, который предоставляется Студенту единожды при регистрации на Сервисе на безвозмездной основе. В процессе обучения в рамках Вводного курса Студенту предоставляется возможность ознакомления с работой Сервиса и определения возможности Студента продолжить обучение в рамках Полного курса по выбранной Студентом Программе обучения. Точное количество часов обучения в рамках Вводного курса зависит от выбранной Студентом Профессии или Курса и определяется в Программе обучения, размещенной на Сервисе. Максимальный срок освоения Вводного курса составляет 1 (один) год с даты начала обучения.
        """)]
    
    private let fontHeader: Font = FontStyleHelper.bold.getStyledFont(size: 24)
    private let fontText: Font = FontStyleHelper.regular.getStyledFont(size: 17)
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                ForEach(elements, id: \.header) { element in
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
