//
//  ImageDetailsViewModel.swift
//  16Tiles
//
//  Created by Alexia Aldea on 19/09/2026.
//

import Foundation
import Combine

class ImageDetailsViewModel: BaseViewModel {
    private let userDefaultsService = UserDefaultsService.shared
    
    let image: UnsplashPhoto
    
    @Published var isInProgress: Bool
    
    var gridSize: Int
    var timerDuration: Int
    
    init(image: UnsplashPhoto, isInProgress: Bool) {
        self.image = image
        self.isInProgress = isInProgress
        
        self.gridSize = userDefaultsService.getValue(key: UserDefaultsKeys.gridSize) ?? 4
        self.timerDuration = userDefaultsService.getValue(key: UserDefaultsKeys.countdownTimer) ?? 90
    }
}
