//
//  MainBgView.swift
//  16Tiles
//
//  Created by Alexia Aldea on 19/09/2026.
//

import SwiftUI

struct MainBgView: View {
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            RadialGradient(colors: [.accent, .clear],
                           center: .topLeading,
                           startRadius: 20,
                           endRadius: 400
            ).ignoresSafeArea()
            
            RadialGradient(colors: [.backgroundSecondary, .clear],
                           center: .bottomTrailing,
                           startRadius: 20,
                           endRadius: 400
            ).ignoresSafeArea()
        }
    }
}

#Preview {
    MainBgView()
}
