//
//  BackButton.swift
//  16Tiles
//
//  Created by Alexia Aldea on 19/09/2026.
//

import SwiftUI

struct BackButton: View {
    @EnvironmentObject private var navigation: Navigation
    var imageColor: Color = .textPrimary
    
    var body: some View {
        Button {
            navigation.pop(animated: true)
        } label: {
            Image(.icNavUp)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(imageColor)
                .frame(width: 24, height: 24)
        }
    }
}
