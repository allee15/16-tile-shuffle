//
//  ModalChooseOptionView.swift
//  16Tiles
//
//  Created by Alexia Aldea on 20/09/2026.
//


import SwiftUI

struct ModalChooseOptionView: View {
    let title: String
    let description: String
    @Binding var username: String
    @Binding var errorMessage: String?
    let topButtonText: String
    var bottomButtonText: String?
    let onTopButtonTapped: () -> ()
    var onBottomButtonTapped: (() -> ())?
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Image(.icConfetti)
                    .resizable()
                    .frame(width: 36, height: 36)
                    .padding(.bottom, 8)
                
                Text(title)
                    .font(.semiBold(size: 24))
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 24)
                
                Text(description)
                    .font(.regular(size: 16))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 24)
                
                FloatingField(text: $username,
                              placeHolder: "Username",
                              errorMessage: errorMessage)
                .padding(.bottom, 24)
                
                VStack(spacing: 12) {
                    PrimaryButtonView(text: topButtonText) {
                        onTopButtonTapped()
                    }
                    
                    if let onBottomButtonTapped = onBottomButtonTapped,
                       let bottomButtonText = bottomButtonText {
                        SecondaryButtonView(text: bottomButtonText) {
                            onBottomButtonTapped()
                        }
                    }
                }
            }.padding(.all, 20)
                .background(Color.white.cornerRadius(8))
                .padding(.horizontal, 24)
        }.ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

