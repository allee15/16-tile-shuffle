//
//  ImageDetailsViewModel.swift
//  16Tiles
//
//  Created by Alexia Aldea on 19/09/2026.
//

import Foundation
import Combine

enum PuzzleState {
    case started
    case notStarted
    case won
}

enum SavingCompletion {
    case saved
}

class ImageDetailsViewModel: BaseViewModel {
    private let userDefaultsService = UserDefaultsService.shared
    private let gameSessionStore = GameSessionStore.shared
    
    let image: UnsplashPhoto
    
    @Published var isInProgress: Bool
    @Published var puzzleState: PuzzleState = .notStarted
    @Published var winnerUsername: String = ""
    @Published var winnerErrorMess: String?
    
    var gridSize: Int
    var timerDuration: Int
    var currentSession: GameSession? {
        gameSessionStore.session(forImageId: image.id)
    }
    var canStartNewGame: Bool {
        let maxGames = userDefaultsService.getValue(key: UserDefaultsKeys.maxParallelGames) ?? GamesDefaults.maxParallelGames
        return isInProgress || gameSessionStore.activeSessionsCount < maxGames
    }
    
    @Published var remainingSeconds: Int = 0
    private var timerCancellable: AnyCancellable?
    private var currentTilesState: [Int] = []
    
    let eventSubject = PassthroughSubject<SavingCompletion, Never>()
    
    init(image: UnsplashPhoto) {
        self.image = image
        self.isInProgress = gameSessionStore.hasActiveSession(forImageId: image.id)
        
        self.gridSize = userDefaultsService.getValue(key: UserDefaultsKeys.gridSize) ?? 4
        self.timerDuration = userDefaultsService.getValue(key: UserDefaultsKeys.countdownTimer) ?? 90
    }
    
    func startGame() {
        if let existing = gameSessionStore.session(forImageId: image.id) {
            puzzleState = .started
            remainingSeconds = existing.remainingSeconds
            isInProgress = true
            resumeCountdown()
        } else {
            puzzleState = .started
            remainingSeconds = timerDuration
            isInProgress = true
            
            gameSessionStore.createSession(imageId: image.id,
                                           imageUrl: image.urls.full,
                                           gridSize: gridSize,
                                           timerDuration: timerDuration)
            resumeCountdown()
        }
    }
    
    func resumeCountdown() {
        guard puzzleState == .started, remainingSeconds > 0 else {return}
        timerCancellable?.cancel()
        
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [weak self] _ in
                self?.tickTimer()
            })
    }
    
    private func tickTimer() {
        guard remainingSeconds > 0 else {return}
        remainingSeconds -= 1
        
        if remainingSeconds == 0 {
            timerCancellable?.cancel()
            handleTimeUp()
        }
    }
    
    private func handleTimeUp() {
        puzzleState = .notStarted
        gameSessionStore.failAllActiveSessions()
        isInProgress = false
    }
    
    func handleWin() {
        timerCancellable?.cancel()
        puzzleState = .won
    }
    
    func submitWinner() {
        guard !winnerUsername.isEmpty else {
            winnerErrorMess = "Please enter a username"
            return
        }
        
        let entry = WinnerEntry(username: winnerUsername,
                                imageId: image.id,
                                timeTaken: timerDuration - remainingSeconds,
                                parallelGamesCount: gameSessionStore.activeSessionsCount)
        gameSessionStore.saveWinner(entry: entry)
        gameSessionStore.markWon(imageId: image.id)
        
        puzzleState = .notStarted
        winnerUsername = ""
        isInProgress = false
    }
    
    func updateTilesState(tiles: [Int]) {
        currentTilesState = tiles
    }
    
    func savePuzzleState() {
        timerCancellable?.cancel()
        gameSessionStore.updateSession(imageId: image.id,
                                       tilesState: currentTilesState,
                                       remainingSeconds: remainingSeconds)
        
        self.eventSubject.send(.saved)
    }
}
