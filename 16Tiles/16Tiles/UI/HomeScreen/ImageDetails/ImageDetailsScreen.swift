//
//  ImageDetailsScreen.swift
//  16Tiles
//
//  Created by Alexia Aldea on 19/09/2026.
//

import SwiftUI
import Kingfisher

struct ImageDetailsScreen: View {
    @EnvironmentObject private var navigation: Navigation
    @StateObject var viewModel: ImageDetailsViewModel
    
    @State private var isTruncated: Bool = false
    @State private var showDescription: Bool = false
    
    var body: some View {
        ZStack {
            MainBgView()
            
            VStack(spacing: 24) {
                HStack {
                    BackButton()
                    Spacer()
                }
                
                VStack(alignment: .center, spacing: 12) {
                    Text("\(viewModel.timerDuration / 60):\(viewModel.timerDuration % 60) min")
                        .font(.bold(size: 24))
                        .foregroundStyle(Color.textPrimary)
                    
                    Text("\(viewModel.gridSize)x\(viewModel.gridSize)")
                        .font(.medium(size: 18))
                        .foregroundStyle(Color.textPrimary)
                }
                
                KFImage(URL(string: viewModel.image.urls.full))
                    .resizable()
                    .placeholder {
                        Image(.imgPlaceholder)
                            .resizable()
                    }
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(8, corners: .allCorners)
                    .clipped()
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.image.title)
                            .font(.medium(size: 18))
                            .foregroundStyle(Color.textPrimary)
                            .lineLimit(5)
                            .background(
                                GeometryReader { limitedGeo in
                                    Text(viewModel.image.title)
                                        .font(.medium(size: 18))
                                        .foregroundStyle(Color.textPrimary)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .hidden()
                                        .background(
                                            GeometryReader { geo in
                                                Color.clear
                                                    .onAppear {
                                                        isTruncated = geo.size.height > limitedGeo.size.height
                                                    }
                                            }
                                        )
                                }
                            )
                            .onTapGesture {
                                if isTruncated {
                                    showDescription = true
                                }
                            }
                        
                        Text(viewModel.image.artistName)
                            .font(.medium(size: 14))
                            .foregroundStyle(Color.textSecondary)
                    }
                    
                    Spacer()
                }
                
                Spacer()
                
                PrimaryButtonView(text: viewModel.isInProgress ? "Continue puzzle" : "Start") {
                    //start game
                }
            }
            .padding(.all, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .sheet(isPresented: $showDescription) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        Text(viewModel.image.title)
                            .font(.medium(size: 18))
                            .foregroundStyle(Color.textPrimary)
                    }
                }
                .padding(.top, 32)
                .padding(.horizontal, 20)
                .presentationDetents([.medium, .large])
            }
        }
    }
}
