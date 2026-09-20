//
//  RankingScreen.swift
//  16Tiles
//
//  Created by Alexia Aldea on 19/09/2026.
//

import SwiftUI

struct RankingScreen: View {
    @StateObject private var viewModel = RankingViewModel()
    
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
                        if viewModel.allWinners.count > 0 {
                            ForEach(viewModel.allWinners.indices, id: \.self) { index in
                                WidgetView(winner: viewModel.allWinners[index], place: index + 1)
                            }
                        } else {
                            Text("No ranks to display.")
                                .font(.medium(size: 20))
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
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
    let winner: WinnerEntry
    let place: Int
    
    var body: some View {
        HStack(spacing: 8) {
            Text("\(place)")
                .font(.bold(size: 20))
                .foregroundColor(textColor)
            
            Text(winner.username + ": \(winner.timeTaken / 60):\(winner.timeTaken & 60) mins, \(winner.parallelGamesCount) parallel games ")
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
