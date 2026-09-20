//
//  HomeScreen.swift
//  16Tiles
//
//  Created by Alexia Aldea on 19/09/2026.
//

import SwiftUI
import Kingfisher

/*
//TODO: luni
 - cum se face ranking-ul
 - daca sunt 3 minute la countdown, userul il mai poate modifica din ecranul de setari? "When the start button is clicked, the countdown timer starts 3 minutes." ; "Settings screen where the we can parametrize the following: The duration of the countdown timer."
- cum fac regula de punctaj daca are jocuri in paralel in progres ? "Winners list screen, ranking should take into account the number of parallel games if the case."
 - Intreaba de librarii daca e ok sa le fol
 */

struct HomeScreen: View {
    @EnvironmentObject private var navigation: Router
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            MainBgView()
            
            VStack(spacing: 0) {
                HomeNavBarView(title: "16Tiles") {
                    navigation.push(.menu)
                }
                
                if viewModel.isLoading {
                    VStack {
                        Spacer()
                        LoaderView()
                        Spacer()
                    }
                } else if viewModel.hasError {
                    VStack {
                        Spacer()
                        Text("An error has occured. Please try again later.")
                            .font(.medium(size: 20))
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                } else {
                    VStack(spacing: 16) {
                        FloatingField(text: $viewModel.query,
                                      placeHolder: "Search a category",
                                      icon: .icSearch,
                                      errorMessage: viewModel.searchErrorMessage)
                        .submitLabel(.search)
                        .onSubmit {
                            viewModel.search()
                        }
                        
                        if viewModel.images.isEmpty {
                            VStack {
                                Spacer()
                                Text("No images to display.")
                                    .font(.medium(size: 20))
                                    .foregroundColor(.textSecondary)
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }
                        } else {
                            ScrollView(showsIndicators: false) {
                                LazyVStack(spacing: 20) {
                                    ForEach(viewModel.images, id: \.id) { image in
                                        HomeImageCardView(image: image, isInProgress: viewModel.imageHasActiveSession(imageId: image.id)) {
                                            navigation.push(.imageDetails(image))
                                        }.onAppear {
                                            if viewModel.images.last?.id == image.id {
                                                viewModel.loadMorePages()
                                            }
                                        }
                                    }
                                    
                                    if viewModel.isLoadingPage {
                                        LoaderView()
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical, 20)
                }
            }
            .padding([.top, .horizontal], 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
        }
    }
}

fileprivate struct HomeImageCardView: View {
    let image: UnsplashPhoto
    let isInProgress: Bool
    let onTap: () -> ()
    
    var body: some View {
        Button {
            onTap()
        } label: {
            VStack(spacing: 12) {
                KFImage(URL(string: image.urls.regular))
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
                    VStack(alignment: .leading, spacing: 4) {
                        Text(image.title)
                            .font(.medium(size: 18))
                            .foregroundStyle(Color.textPrimary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        Text(image.artistName)
                            .font(.medium(size: 14))
                            .foregroundStyle(Color.textSecondary)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 6) {
                        Text(isInProgress ? "Continue" : "See details")
                            .font(Font.medium(size: 14))
                        
                        Image(.icItemresultArrow)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 16, height: 16)
                        
                    }
                    .foregroundStyle(Color.accentButton)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .overlay(
                        Capsule()
                            .stroke(Color.accentButton, lineWidth: 1)
                    )
                }
                .padding([.horizontal, .bottom], 12)
            }
            .overlay (
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .strokeBorder(borderStyle, lineWidth: isInProgress ? 2.5 : 1)
            )
        }
    }
    
    private var borderStyle: AnyShapeStyle {
        if isInProgress {
            return AnyShapeStyle(Color.accentButton)
        } else {
            return AnyShapeStyle(Color.textSecondary.opacity(0.5))
        }
    }
}

#Preview {
    HomeScreen()
}
