//
//  HomeViewModel.swift
//  16Tiles
//
//  Created by Alexia Aldea on 19/09/2026.
//

import Foundation
import Combine

class HomeViewModel: BaseViewModel {
    private let unsplashService = UnsplashService.shared
    private let userDefaultsService = UserDefaultsService.shared
    private let gameSessionStore = GameSessionStore.shared
    
    @Published var images: [UnsplashPhoto] = []
    @Published var query: String = ""
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
    @Published var searchErrorMessage: String?
    
    private var currentPage = 1
    private var totalPages = 1
    var isLoadingPage = false
    
    private var hasMorePages: Bool { currentPage < totalPages }
        
    override init() {
        super.init()
        self.images = [UnsplashPhoto(id: "1", title: "Test", artistName: "Ion Zapada",
                                            urls: UnsplashUrl(
                                                regular: "https://images.unsplash.com/photo-1773332611516-93826171cef2?q=80&w=987&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",       
                                                full: "https://images.unsplash.com/photo-1773332611516-93826171cef2?q=80&w=987&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"))]
//        self.loadPhotos(page: 1)
    }
    
    private func loadPhotos(page: Int) {
        guard !isLoadingPage else {return}
        self.hasError = false
        
        if page == 1 {
            self.isLoading = true
        } else {
            isLoadingPage = true
        }
        
        let valueKey = userDefaultsService.getValue(key: UserDefaultsKeys.query)
        let queryToUse = !self.query.isEmpty ? query : valueKey
        
        self.unsplashService.getPhotos(query: queryToUse,
                                       page: page)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoadingPage = false
                self?.isLoading = false
                if case .failure(_) = completion {
                    self?.hasError = true
                }
            } receiveValue: { [weak self] result in
                guard let self else {return}
                self.currentPage = page
                self.totalPages = result.totalPages
                
                if page > 1 {
                    self.images = images + result.results
                } else {
                    self.images = result.results
                }
            }.store(in: &bag)
    }
    
    func loadMorePages() {
        guard hasMorePages, !isLoadingPage else {return}
        loadPhotos(page: currentPage + 1)
    }
    
    func search() {
        guard self.query.count > 2 else {
            self.searchErrorMessage = "The query must be at least 3 characters."
            return
        }
        
        currentPage = 1
        totalPages = 1
        searchErrorMessage = nil
        
        self.userDefaultsService.setValue(key: UserDefaultsKeys.query, value: self.query)
        
        loadPhotos(page: 1)
    }
    
    func imageHasActiveSession(imageId: String) -> Bool {
        gameSessionStore.hasActiveSession(forImageId: imageId)
    }
}
