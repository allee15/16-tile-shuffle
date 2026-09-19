//
//  RootView.swift
//  16Tiles
//
//  Created by Alexia Aldea on 19/09/2026.
//

import SwiftUI
import Network
import Combine

enum RootViewModelEvent {
    case goToTabBar
}

class RootViewModel: BaseViewModel {
    let eventSubject = PassthroughSubject<RootViewModelEvent, Never>()
    private let userDefaultsService = UserDefaultsService.shared
    
    private var binded = false
    
    @Published var showBlockingError: Bool = false
    @Published var isLoadingBinding: Bool = false
    
    func bind() {
        showBlockingError = false
        
        guard !binded else {return}
        binded = true
        
        self.userDefaultsService.registerDefaults()
        
        self.eventSubject.send(.goToTabBar)
    }
    
    func retryBinding() {
        showBlockingError = false
        isLoadingBinding = true
        
        bind()
    }
}

struct RootView: View {
    let navigation: Navigation
    
    @StateObject private var viewModel = RootViewModel()
    
    var body: some View {
        ControllerRepresentable(controller: navigation.navigationController)
            .ignoresSafeArea()
            .onReceive(viewModel.eventSubject, perform: { event in
                switch event {
                case .goToTabBar:
                    navigation.replaceNavigationStack([HomeScreen().asDestination()], animated: true)
                }
            }).onAppear {
                viewModel.bind()
            }
    }
}
