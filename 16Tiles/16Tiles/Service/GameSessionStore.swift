//
//  GameSessionStore.swift
//  16Tiles
//
//  Created by Alexia Aldea on 20/09/2026.
//

import Foundation
import SwiftData

class GameSessionStore {
    static let shared = GameSessionStore()
    private let userDefaultsService = UserDefaultsService.shared
    
    private var sessions: [GameSession] = []
    private var winners: [WinnerEntry] = []
    
    private init() {
        load()
        loadWinners()
    }
    
    private func load() {
        guard let data = userDefaultsService.getValue(key: UserDefaultsKeys.gameSessions),
              let decoded = try? JSONDecoder().decode([GameSession].self, from: data) else {
            return
        }
        
        sessions = decoded
    }
    
    func hasActiveSession(forImageId imageId: String) -> Bool {
        sessions.contains { $0.imageId == imageId }
    }
    
    func session(forImageId imageId: String) -> GameSession? {
        sessions.first { $0.imageId == imageId }
    }
    
    var activeSessionsCount: Int {
        sessions.count
    }
    
    func createSession(imageId: String, imageUrl: String, gridSize: Int, timerDuration: Int) {
        let newSession = GameSession(imageId: imageId,
                                     imageUrl: imageUrl,
                                     gridSize: gridSize,
                                     tilesState: [],
                                     remainingSeconds: timerDuration)
        sessions.append(newSession)
        save()
    }
    
    func updateSession(imageId: String, tilesState: [Int], remainingSeconds: Int) {
        guard let index = sessions.firstIndex(where: {$0.imageId == imageId}) else {return}
        sessions[index].tilesState = tilesState
        sessions[index].remainingSeconds = remainingSeconds
        save()
    }
    
    func markWon(imageId: String) {
        sessions.removeAll {$0.imageId == imageId}
        save()
    }
    
    func failAllActiveSessions() {
        sessions.removeAll()
        save()
    }
    
    private func save() {
        guard let data = try? JSONEncoder().encode(sessions) else { return }
        userDefaultsService.setValue(key: UserDefaultsKeys.gameSessions, value: data)
    }
    
    func saveWinner(entry: WinnerEntry) {
        winners.append(entry)
        saveWinners()
    }
    
    var allWinners: [WinnerEntry] {
        winners
    }
    
    private func saveWinners() {
        guard let data = try? JSONEncoder().encode(winners) else { return }
        userDefaultsService.setValue(key: UserDefaultsKeys.winners, value: data)
    }
    
    private func loadWinners() {
        guard let data = userDefaultsService.getValue(key: UserDefaultsKeys.winners),
            let decoded = try? JSONDecoder().decode([WinnerEntry].self, from: data) else { return }
        winners = decoded
    }
}
