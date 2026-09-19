//
//  RankingScreen.swift
//  16Tiles
//
//  Created by Alexia Aldea on 19/09/2026.
//

import SwiftUI

struct Rank {
    var id = UUID()
    let name: String
    let score: Int
}

struct RankingScreen: View {
    let ranks: [Rank] = [
        Rank(name: "Ana", score: 300),
        Rank(name: "Alexia", score: 250),
        Rank(name: "Sergiu", score: 200),
        Rank(name: "Alex", score: 150),
        Rank(name: "Darius", score: 100)
    ]
    
    var body: some View {
        ZStack {
            MainBgView()
            
            VStack(spacing: 24) {
                HStack {
                    BackButton()
                    Spacer()
                }
                
                if ranks.count > 0 {
                    ForEach(ranks.indices, id: \.self) { index in
                        WidgetView(name: ranks[index].name, place: index)
                    }
                }
            }
            .padding([.top, .horizontal], 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

fileprivate struct WidgetView: View {
    let name: String
    let place: Int
    
    var body: some View {
        HStack(spacing: 8) {
            Text("\(place)")
                .font(.bold(size: 20))
                .foregroundColor(textColor)
            
            Text(name)
                .font(.semiBold(size: 18))
                .foregroundColor(.textPrimary)
            
            Spacer()
        }.padding(.horizontal, 16)
            .padding(.vertical, 12)
            .border(Color.textSecondary, width: 1, cornerRadius: 8)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
    }
    
    private var textColor: Color {
        switch place {
        case 1: return .gold
        case 2: return .silver
        case 3: return .bronze
        default: return .textPrimary
        }
    }
}

#Preview {
    RankingScreen()
}
