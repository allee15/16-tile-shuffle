//
//  ActiveGamesScreen.swift
//  16Tiles
//
//  Created by Alexia Aldea on 20/09/2026.
//

import SwiftUI
import Kingfisher

struct ActiveGamesScreen: View {
    @StateObject private var viewModel = ActiveGamesViewModel()
    @EnvironmentObject private var navigation: Router
    
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
                        if viewModel.allSessions.count > 0 {
                            ForEach(viewModel.allSessions) { game in
                                GameSessionCard(game: game, onTap: {
                                    let image = UnsplashPhoto(id: game.imageId,
                                                              title: "",
                                                              artistName: "",
                                                              urls: UnsplashUrl(regular: game.imageUrl, full: game.imageUrl))
                                    navigation.push(.imageDetails(image))
                                })
                            }
                        } else {
                            Text("No games to display.")
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
        .navigationBarHidden(true)
    }
}

fileprivate struct GameSessionCard: View {
    let game: GameSession
    let onTap: () -> ()
    
    var body: some View {
        Button {
            onTap()
        } label: {
            VStack(spacing: 12) {
                KFImage(URL(string: game.imageUrl))
                    .resizable()
                    .placeholder {
                        Image(.imgPlaceholder)
                            .resizable()
                    }
                    .centerCropped()
                    .aspectRatio(1, contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(8, corners: .allCorners)
                
                HStack {
                    Spacer()
                    
                    HStack(spacing: 6) {
                        Text("Continue")
                            .font(Font.medium(size: 14))
                        
                        Image(.icItemresultArrow)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 16, height: 16)
                        
                    }
                    .foregroundStyle(Color.success)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .overlay(
                        Capsule()
                            .stroke(Color.success, lineWidth: 1.5)
                    )
                }
                .padding([.horizontal, .bottom], 12)
            }
            .overlay (
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .strokeBorder(AnyShapeStyle(Color.accentButton), lineWidth: 1)
            )
        }
    }
}

#Preview {
    ActiveGamesScreen()
}
