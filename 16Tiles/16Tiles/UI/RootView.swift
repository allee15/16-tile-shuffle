//
//  RootView.swift
//  16Tiles
//
//  Created by Alexia Aldea on 19/09/2026.
//

import SwiftUI
import Combine

class RootViewModel: BaseViewModel {
    private let userDefaultsService = UserDefaultsService.shared
    
    private var binded = false
    
    func bind() {
        guard !binded else {return}
        binded = true
        
        self.userDefaultsService.registerDefaults()
    }
}

struct RootView: View {
    @StateObject private var router = Router()
    @StateObject private var viewModel = RootViewModel()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            HomeScreen()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .menu:
                        MenuScreen()
                    case .imageDetails(let photo):
                        ImageDetailsScreen(viewModel: ImageDetailsViewModel(image: photo))
                    case .ranking:
                        RankingScreen()
                    case .activeGames:
                        ActiveGamesScreen()
                    }
                }
        }
        .environmentObject(router)
        .onAppear {
            viewModel.bind()
        }
        .navigationBarHidden(true)
    }
}
