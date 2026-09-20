//
//  RankingViewModel.swift
//  16Tiles
//
//  Created by Alexia Aldea on 20/09/2026.
//

import Foundation

class RankingViewModel: BaseViewModel {
    private let userDefaultsService = UserDefaultsService.shared
    private let gameSessionStore = GameSessionStore.shared
    
    var allWinners: [WinnerEntry]
    
    override init() {
        self.allWinners = gameSessionStore.allWinners.sorted(by: {$0.timeTaken < $1.timeTaken})
    }
    
}
