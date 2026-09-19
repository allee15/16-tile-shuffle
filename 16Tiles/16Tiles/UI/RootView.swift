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
    case goToLogin //TODO: alexia
}

class RootViewModel: BaseViewModel {
    let eventSubject = PassthroughSubject<RootViewModelEvent, Never>()
    var userDefaultsService = UserDefaultsService.shared
    
    private var binded = false
    
    @Published var showBlockingError: Bool = false
    @Published var isLoadingBinding: Bool = false
    
    override init() {
        super.init()
        setupErrorHandling()
    }

    func bind() {
        showBlockingError = false
        
        guard !binded else {return}
        binded = true
        
        self.eventSubject.send(.goToTabBar)
    }
    
    func setupErrorHandling() {
        //TODO: alexia
//        noInternetInterceptor.errors()
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] errorEvent in
//                self?.showBlockingError = true
//            }
//            .store(in: &bag)
    }
    
    func retryBinding() {
        showBlockingError = false
        isLoadingBinding = true
        
        bind()
    }
}

struct RootView: View {
    private let mainNavigation = EnvironmentObjects.navigation
    let navigation: Navigation
    
    @StateObject private var viewModel = RootViewModel()
    
//    @ObservedObject private var toastManager = ToastManager.instance TODO: alexia
    
    var body: some View {
        ControllerRepresentable(controller: navigation.navigationController)
            .ignoresSafeArea()
            .onReceive(viewModel.eventSubject, perform: { event in
                switch event {
                case .goToTabBar:
                    navigation.replaceNavigationStack([HomeScreen().asDestination()], animated: true)
                case .goToLogin:
                    break
                }
            }).onAppear {
                viewModel.bind()
            }
//            .overlay(
//                VStack {
//                    if let toast = toastManager.toast {
//                        ToastView(toast: toast)
//                            .padding(SafeAreaInsets)
//                            .transition(.move(edge: .top))
//                            .onTapGesture {
//                                toastManager.hideToast()
//                            }.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
//                                .onEnded({ value in
//                                    if value.translation.height < 0 {
//                                        toastManager.hideToast()
//                                    }
//                                }))
//                    }
//                    Spacer()
//                }
//                    .ignoresSafeArea()
//                    .animation(.easeIn(duration: 0.25), value: toastManager.toast)
//            ) TODO: alexia
//            .overlay {
//                VStack {
//                    if viewModel.showBlockingError {
//                        BlockingErrorScreen() {
//                            viewModel.retryBinding()
//                        }
//                    }
//                } TODO: alexia
//            }
    }
}
