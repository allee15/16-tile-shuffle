//
//  UserDefaultsService.swift
//  16Tiles
//
//  Created by Alexia Aldea on 19/09/2026.
//

import Foundation

enum UserDefaultsKeys {
    static let query: Key<String> = Key(value: "query")
    static let countdownTimer: Key<Int> = Key(value: "countdownTimer")
    static let gridSize: Key<Int> = Key(value: "gridSize")
    static let maxParallelGames: Key<Int> = Key(value: "maxParallelGames")
    static let gameSessions: Key<Data> = Key(value: "gameSessions")
    static let winners: Key<Data> = Key(value: "winners")
}

enum GamesDefaults {
    static let query = "nature"
    static let countdownTimer = 180
    static let gridSize = 4
    static let maxParallelGames = 5
}

public struct Key<T> {
    let value: String
}

class UserDefaultsService {
    static let shared = UserDefaultsService()
    
    private let defaults: UserDefaults
    
    private init() {
        defaults = UserDefaults.standard
    }
    
    func registerDefaults() {
        defaults.register(defaults: [
            UserDefaultsKeys.query.value: GamesDefaults.query,
            UserDefaultsKeys.countdownTimer.value: GamesDefaults.countdownTimer,
            UserDefaultsKeys.gridSize.value: GamesDefaults.gridSize,
            UserDefaultsKeys.maxParallelGames.value: GamesDefaults.maxParallelGames
        ])
    }
    
    func setValue<T>(key: Key<T>, value: Optional<T>) {
        defaults.set(value, forKey: key.value)
    }
    
    func getValue<T>(key: Key<T>) -> Optional<T> {
        return defaults.object(forKey: key.value) as? T
    }
}
