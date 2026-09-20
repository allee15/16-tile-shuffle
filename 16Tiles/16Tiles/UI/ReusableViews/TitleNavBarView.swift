//
//  TitleNavBarView.swift
//  16Tiles
//
//  Created by Alexia Aldea on 19/09/2026.
//

import SwiftUI

struct TitleNavBarView: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.semiBold(size: 28))
                .foregroundStyle(
                    LinearGradient(colors: [.textPrimary, .accentButton],
                                   startPoint: .leading,
                                   endPoint: .trailing)
                )
            
            Spacer()
        }
    }
}

struct HomeNavBarView: View {
    let title: String
    let action: () -> ()
    
    var body: some View {
        HStack {
            TitleNavBarView(title: title)
            
            Spacer()
            
            Button {
                action()
            } label: {
                Image(.icMenu)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.textPrimary)
                    .frame(width: 24, height: 24)
            }
        }
    }
}
