//
//  ActiveGamesViewModel.swift
//  16Tiles
//
//  Created by Alexia Aldea on 20/09/2026.
//

import Foundation
import Combine

class ActiveGamesViewModel: BaseViewModel {
    private let gamesSessionStore = GameSessionStore.shared
    
    var allSessions: [GameSession]
    
    override init() {
        self.allSessions = gamesSessionStore.allActiveSessions
    }
}
