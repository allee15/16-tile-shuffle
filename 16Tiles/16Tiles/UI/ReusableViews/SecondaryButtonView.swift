//
//  SecondaryButtonView.swift
//  16Tiles
//
//  Created by Alexia Aldea on 19/09/2026.
//


import SwiftUI

struct SecondaryButtonView: View {
    let text: String
    var borderColor: Color = Color.accentButton
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
                    .foregroundColor(borderColor)
                    .lineLimit(1)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth:.infinity)
                
                Spacer()
            }.padding(.vertical, 12)
                .border(borderColor, width: 1, cornerRadius: 8)
        }.disabled(isDisabled)
    }
}
