//
//  CustomSearchBar.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/28/25.
//

import SwiftUI

struct CustomSearchBar: View {
    
    @Binding var searchText: String

    @State private var magnifyingGlassColor: Color = .ypGrayConstant
    @FocusState private var focusState: Bool
    @Binding var isFocused: Bool
    
    var placeholder = "Введите запрос"

    var body: some View {
        HStack (spacing: 0) {
            HStack (spacing: 0) {
                HStack {
                    TextField(placeholder, text: $searchText)
                        .font(.system(size: 17))
                        .padding(.leading, 8)
                        .autocorrectionDisabled(true)
                        .autocapitalization(.none)
                        .focused($focusState)
                }
                .padding()
                .cornerRadius(16)
                .padding(.horizontal)
                .overlay {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 17, height: 17)
                            .foregroundColor(magnifyingGlassColor)
                        
                        Spacer()

                        Button {
                            searchText = ""
                        }
                        label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.ypGrayConstant)
                                .padding(.vertical)
                        }
                        .opacity(focusState && !searchText.isEmpty ? 1 : 0)
                        .disabled(!focusState && searchText.isEmpty)
                    }
                    .padding(.horizontal, 10)
                }
            }
            .frame(height: 37)
            .background(.ypLightGrayConstant)
            .cornerRadius(10)
            .onChange(of: searchText) { oldText, newText in
                withAnimation {
                    magnifyingGlassColor = newText.isEmpty ? .ypGrayConstant : .ypBlack
                }
            }
            .onChange(of: focusState) { oldFocus, newFocus in
                if newFocus {
                    isFocused = true
                }
            }
            .onChange(of: isFocused) { oldFocus, newFocus in
                print("Focus changed: \(newFocus)")
                if !newFocus {
                    focusState = false
                }
            }
        }
        .frame(height: 37)
        .padding(.horizontal, 16)
    }
}
