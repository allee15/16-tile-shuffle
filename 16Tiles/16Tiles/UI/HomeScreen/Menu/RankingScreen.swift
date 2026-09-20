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
            
            VStack(spacing: 0) {
                HStack {
                    BackButton()
                    Spacer()
                }
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        if ranks.count > 0 {
                            ForEach(ranks.indices, id: \.self) { index in
                                WidgetView(rank: ranks[index], place: index + 1)
                            }
                        }
                    }
                }
                .padding(.top, 20)
            }
            .padding([.top, .horizontal], 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

fileprivate struct WidgetView: View {
    let rank: Rank
    let place: Int
    
    var body: some View {
        HStack(spacing: 8) {
            Text("\(place)")
                .font(.bold(size: 20))
                .foregroundColor(textColor)
            
            Text(rank.name + ": \(rank.score) points")
                .font(.semiBold(size: 18))
                .foregroundColor(.textSecondary)
            
            Spacer()
        }.padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .overlay (
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .strokeBorder(Color.accentButton, lineWidth: 1.5)
            )
    }
    
    private var textColor: Color {
        switch place {
        case 1: return .gold
        case 2: return .silver
        case 3: return .bronze
        default: return .textPrimary.opacity(0.6)
        }
    }
}

#Preview {
    RankingScreen()
}
