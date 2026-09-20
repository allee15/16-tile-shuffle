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
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var isTruncated: Bool = false
    @State private var showDescription: Bool = false
    
    var body: some View {
        ZStack {
            MainBgView()
            
            VStack(spacing: 24) {
                HStack {
                    BackButton {
                        if viewModel.puzzleState == .started {
                            viewModel.pauseCountdown()
                        } else {
                            navigation.pop(animated: true)
                        }
                    }
                    Spacer()
                }
                
                switch viewModel.puzzleState {
                case .started:
                    StartedGameView(viewModel: viewModel)
                    
                case .notStarted:
                    NotStartedGameView(viewModel: viewModel, isTruncated: $isTruncated, showDescription: $showDescription)
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
        .onChange(of: scenePhase) { oldValue, newValue in
            switch newValue {
            case .active:
                viewModel.resumeCountdown()
            case .background, .inactive:
                viewModel.pauseCountdown()
            default:
                break
            }
        }
    }
}

fileprivate struct NotStartedGameView: View {
    @ObservedObject var viewModel: ImageDetailsViewModel
    @Binding var isTruncated: Bool
    @Binding var showDescription: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("\(viewModel.timerDuration / 60):\(viewModel.timerDuration % 60) min")
                .font(.bold(size: 24))
                .foregroundStyle(Color.textPrimary)
            
            Text("\(viewModel.gridSize)x\(viewModel.gridSize)")
                .font(.medium(size: 18))
                .foregroundStyle(Color.textSecondary)
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
            viewModel.startGame()
        }
    }
}

fileprivate struct StartedGameView: View {
    @ObservedObject var viewModel: ImageDetailsViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text("\(viewModel.remainingSeconds / 60):\(viewModel.remainingSeconds % 60) min")
                .font(.bold(size: 24))
                .foregroundStyle(Color.textPrimary)
            
            PuzzleView(imageUrlString: viewModel.image.urls.full, gridSize: viewModel.gridSize)
        }
    }
}
