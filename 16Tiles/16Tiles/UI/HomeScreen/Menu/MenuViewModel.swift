//
//  MenuViewModel.swift
//  16Tiles
//
//  Created by Alexia Aldea on 19/09/2026.
//

import Foundation
import Combine

enum MenuState {
    case completed
}

class MenuViewModel: BaseViewModel {
    private let userDefaultsService = UserDefaultsService.shared
    
    @Published var countdownTimer: String
    @Published var gridSize: String
    @Published var maxParallelGames: String
    
    @Published var timerErrorMessage: String?
    @Published var gridErrorMessage: String?
    @Published var parallelGamesErrorMessage: String?
    
    private let originalCountdownTimer: String
    private let originalGridSize: String
    private let originalMaxParallelGames: String
    
    let eventSubject = PassthroughSubject<MenuState, Never>()
    
    var hasChanges: Bool {
        countdownTimer != originalCountdownTimer
        || gridSize != originalGridSize
        || maxParallelGames != originalMaxParallelGames
    }
    
    var hasErrors: Bool {
        timerErrorMessage != nil || gridErrorMessage != nil || parallelGamesErrorMessage != nil
    }
    
    var isSaveDisabled: Bool {
        !hasChanges || hasErrors
    }
    
    override init() {
        let timer = String(userDefaultsService.getValue(key: UserDefaultsKeys.countdownTimer) ?? GamesDefaults.countdownTimer)
        let grid = String(userDefaultsService.getValue(key: UserDefaultsKeys.gridSize) ?? GamesDefaults.gridSize)
        let parallel = String(userDefaultsService.getValue(key: UserDefaultsKeys.maxParallelGames) ?? GamesDefaults.maxParallelGames)
        
        self.countdownTimer = timer
        self.gridSize = grid
        self.maxParallelGames = parallel
        
        self.originalCountdownTimer = timer
        self.originalGridSize = grid
        self.originalMaxParallelGames = parallel
    }
    
    func save() {
        if Int(countdownTimer) ?? 0 < 180 {
            timerErrorMessage = "Timer must be at least 180 seconds."
        }
        
        if Int(gridSize) ?? 0 < 4 || Int(gridSize) ?? 0 > 16 {
            gridErrorMessage = "Grid size must be between 4 and 16."
        }
        
        if Int(maxParallelGames) ?? 0 < 1 || Int(maxParallelGames) ?? 0 > 5 {
            parallelGamesErrorMessage = "Max parallel games must be between 1 and 5."
        }
        
        if timerErrorMessage == nil && gridErrorMessage == nil && parallelGamesErrorMessage == nil {
            let countdownTimer = Int(self.countdownTimer) ?? GamesDefaults.countdownTimer
            let gridSize = Int(self.gridSize) ?? GamesDefaults.gridSize
            let maxParallelGames = Int(self.maxParallelGames) ?? GamesDefaults.maxParallelGames
            
            userDefaultsService.setValue(key: UserDefaultsKeys.countdownTimer, value: countdownTimer)
            userDefaultsService.setValue(key: UserDefaultsKeys.gridSize, value: gridSize)
            userDefaultsService.setValue(key: UserDefaultsKeys.maxParallelGames, value: maxParallelGames)
            
            self.eventSubject.send(.completed)
        }
    }
}
