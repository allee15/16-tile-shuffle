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
    
    private let container: ModelContainer
    private let context: ModelContext
    
    private init() {
        do {
            container = try ModelContainer(for: GameSession.self, WinnerEntry.self)
            context = ModelContext(container)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    private func fetchAllSessions() -> [GameSession] {
        (try? context.fetch(FetchDescriptor<GameSession>())) ?? []
    }
    
    func hasActiveSession(forImageId imageId: String) -> Bool {
        fetchAllSessions().contains { $0.imageId == imageId }
    }
    
    func session(forImageId imageId: String) -> GameSession? {
        fetchAllSessions().first { $0.imageId == imageId }
    }
    
    var activeSessionsCount: Int {
        fetchAllSessions().count
    }
    
    var allActiveSessions: [GameSession] {
        fetchAllSessions()
    }
    
    func createSession(imageId: String, imageUrl: String, gridSize: Int, timerDuration: Int) {
        let newSession = GameSession(imageId: imageId,
                                     imageUrl: imageUrl,
                                     gridSize: gridSize,
                                     tilesState: [],
                                     remainingSeconds: timerDuration)
        context.insert(newSession)
        save()
    }
    
    func updateSession(imageId: String, tilesState: [Int], remainingSeconds: Int) {
        guard let session = session(forImageId: imageId) else {return}
        session.tilesState = tilesState
        session.remainingSeconds = remainingSeconds
        save()
    }
    
    func markWon(imageId: String) {
        guard let session = session(forImageId: imageId) else {return}
        context.delete(session)
        save()
    }
    
    func failAllActiveSessions() {
        for session in allActiveSessions {
            context.delete(session)
        }
        save()
    }
    
    func saveWinner(entry: WinnerEntry) {
        context.insert(entry)
        save()
    }
    
    var allWinners: [WinnerEntry] {
        (try? context.fetch(FetchDescriptor<WinnerEntry>())) ?? []
    }
    
    private func save() {
        try? context.save()
    }
}
