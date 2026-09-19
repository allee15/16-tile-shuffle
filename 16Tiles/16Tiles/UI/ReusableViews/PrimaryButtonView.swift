//
//  PrimaryButtonView.swift
//  16Tiles
//
//  Created by Alexia Aldea on 19/09/2026.
//


import SwiftUI

struct PrimaryButtonView: View {
    let text: String
    var bgColor: Color = Color.accentButton
    var textColor: Color = Color.white
    var isDisabled: Bool = false
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Spacer()
                
                Text(text)
                    .font(.medium(size: 18))
                    .foregroundColor(textColor)
                    .lineLimit(1)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth:.infinity)
                
                Spacer()
            }.padding(.vertical, 12)
                .background(isDisabled ? .textSecondary.opacity(0.5) : bgColor)
                .cornerRadius(8, corners: .allCorners)
        }.disabled(isDisabled)
    }
}

