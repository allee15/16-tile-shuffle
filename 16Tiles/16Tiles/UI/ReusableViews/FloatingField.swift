//
//  FloatingField.swift
//  16Tiles
//
//  Created by Alexia Aldea on 19/09/2026.
//

import SwiftUI

struct FloatingField: View {
    @Binding var text: String
    var placeHolder: String? = nil
    var keyboardType: UIKeyboardType = .default
    var colors: (bgColor: Color, borderColor: Color, placeholderForeground: Color) = (.textSecondary.opacity(0.15), .textPrimary.opacity(0.7), .textSecondary)
    var icon: ImageResource?
    var errorMessage: String? = nil
    @State private var secure: Bool = true
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack {
                HStack {
                    if $text.wrappedValue.isEmpty {
                        if let placeHolder = placeHolder {
                            Text(placeHolder)
                                .foregroundColor(colors.placeholderForeground)
                                .font(.regular(size: 14))
                                .multilineTextAlignment(.leading)
                        }
                    } else if let placeHolder = placeHolder {
                        Text(placeHolder)
                            .foregroundColor(colors.placeholderForeground)
                            .font(.regular(size: 14))
                            .scaleEffect(0.75, anchor: .leading)
                            .offset(y: -12)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                            .truncationMode(.middle)
                            .padding(.top, 12)
                            .padding(.bottom, 6)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                
                TextField(text: $text) {
                }
                .keyboardType(keyboardType)
                .textInputAutocapitalization(.never)
                .foregroundColor(.textPrimary)
                .font(.regular(size: 14))
                .padding(.leading, 16)
                .offset(y: placeHolder != nil ? ($text.wrappedValue.isEmpty ? 0 : 4) : 0 )
                .padding(.trailing, 16)
                
                HStack {
                    Spacer()
                    if let icon = icon {
                        Image(icon)
                            .resizable()
                            .foregroundStyle(Color.textPrimary)
                            .frame(width: 24, height: 24)
                            .padding(.trailing, 16)
                    }
                }
            }
            .frame(height: 54)
            .animation(placeHolder != nil ? customAnimation() : nil, value: text)
            .background((errorMessage ?? "").isEmpty ? colors.bgColor : Color.danger.opacity(0.3))
            .cornerRadius(4, corners: .allCorners)
            .border((errorMessage ?? "").isEmpty ? colors.borderColor : Color.danger,
                    width: 1,
                    cornerRadius: 4)
            
            if let errorMessage = errorMessage {
                HStack {
                    Text(errorMessage)
                        .font(.regular(size: 12))
                        .foregroundColor(Color.danger)
                    Spacer()
                }
                .padding(.top, 4)
            }
        }
    }
    
    func customAnimation() -> Animation {
        return Animation.linear(duration: 0.2)
    }
}
