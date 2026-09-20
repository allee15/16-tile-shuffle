//
//  MenuScreen.swift
//  16Tiles
//
//  Created by Alexia Aldea on 19/09/2026.
//

import SwiftUI

struct MenuScreen: View {
    @StateObject private var viewModel = MenuViewModel()
    @EnvironmentObject private var navigation: Router
    
    var body: some View {
        ZStack {
            MainBgView()
            
            VStack(spacing: 24) {
                HStack {
                    BackButton()
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    FloatingField(text: $viewModel.countdownTimer,
                                  placeHolder: "Countdown timer",
                                  keyboardType: .numberPad,
                                  errorMessage: viewModel.timerErrorMessage)
                    .onChange(of: viewModel.countdownTimer) { _, _ in
                        viewModel.timerErrorMessage = nil
                    }
                    
                    FloatingField(text: $viewModel.gridSize,
                                  placeHolder: "Grid size",
                                  keyboardType: .numberPad,
                                  errorMessage: viewModel.gridErrorMessage)
                    .onChange(of: viewModel.gridSize) { _, _ in
                        viewModel.gridErrorMessage = nil
                    }
                    
                    FloatingField(text: $viewModel.maxParallelGames,
                                  placeHolder: "Maximum parallel games",
                                  keyboardType: .numberPad,
                                  errorMessage: viewModel.parallelGamesErrorMessage)
                    .onChange(of: viewModel.maxParallelGames) { _, _ in
                        viewModel.parallelGamesErrorMessage = nil
                    }
                    
                    Spacer()
                    
                    SecondaryButtonView(text: "Check ranking list") {
                        navigation.push(.ranking)
                    }
                    
                    SecondaryButtonView(text: "Continue active games") {
                        navigation.push(.activeGames)
                    }
                    
                    PrimaryButtonView(text: "Save", isDisabled: viewModel.isSaveDisabled) {
                        viewModel.save()
                    }
                }
            }
            .padding([.top, .horizontal], 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onReceive(viewModel.eventSubject) { event in
                switch event {
                case .completed:
                    navigation.pop()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    MenuScreen()
}
