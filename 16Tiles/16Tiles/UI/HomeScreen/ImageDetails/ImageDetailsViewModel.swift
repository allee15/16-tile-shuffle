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
}

class ImageDetailsViewModel: BaseViewModel {
    private let userDefaultsService = UserDefaultsService.shared
    
    let image: UnsplashPhoto
    
    @Published var isInProgress: Bool
    @Published var puzzleState: PuzzleState = .notStarted
    
    var gridSize: Int
    var timerDuration: Int
    
    @Published var remainingSeconds: Int = 0
    private var startedAt: Date?
    private var timerCancellable: AnyCancellable?
    
    init(image: UnsplashPhoto, isInProgress: Bool) {
        self.image = image
        self.isInProgress = isInProgress
        
        self.gridSize = userDefaultsService.getValue(key: UserDefaultsKeys.gridSize) ?? 4
        self.timerDuration = userDefaultsService.getValue(key: UserDefaultsKeys.countdownTimer) ?? 90
    }
    
    func startGame() {
        puzzleState = .started
        startedAt = Date()
        remainingSeconds = timerDuration
        
        startCountdown()
    }
    
    func startCountdown() {
        timerCancellable?.cancel()
        
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [weak self] _ in
                self?.tickTimer()
            })
    }
    
    private func tickTimer() {
        guard let startedAt else {return}
        
        let elapsed = Int(Date().timeIntervalSince(startedAt))
        let remaining = timerDuration - elapsed
        
        if remaining <= 0 {
            remainingSeconds = 0
            timerCancellable?.cancel()
            handleTimeUp()
        } else {
            remainingSeconds = remaining
        }
    }
    
    private func handleTimeUp() {
        puzzleState = .notStarted
        //joc pierdut + toate celelalte sunt pierdute
    }
    
    func savePuzzleAndExit() {
        timerCancellable?.cancel()
        //de persistat startedAt + starea gridului 
    }
}
