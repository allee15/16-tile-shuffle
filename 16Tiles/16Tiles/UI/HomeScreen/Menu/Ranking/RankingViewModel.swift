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
    
    var allWinners: [WinnerEntry] = []
    
    override init() {
        super.init()
        self.allWinners = gameSessionStore.allWinners.sorted {
            score($0) > score($1)
        }
    }
    
    func score(_ winner: WinnerEntry) -> Int {
        let baseScore = 1000.0 / Double(max(winner.timeTaken, 1))
        let parallelBonusPercentage = Double(winner.parallelGamesCount - 1) * 0.20
        let finalScore = baseScore * (1 + parallelBonusPercentage)
        return Int(finalScore.rounded())
    }
    
    func scoreDescription(_ winner: WinnerEntry) -> String {
        let minutes = winner.timeTaken / 60
        let seconds = winner.timeTaken % 60
        let gamesLabel = winner.parallelGamesCount == 1 ? "game" : "games"
        
        return "\(winner.username): \(minutes):\(seconds) mins, \(winner.parallelGamesCount) parallel \(gamesLabel)\n Score: \(score(winner)) pts" +
        "\nScore = (1000 % time in seconds) * (1 + 20% for each additional parallel game). Faster times and more simultaneous games earn a higher score."
    }
}
