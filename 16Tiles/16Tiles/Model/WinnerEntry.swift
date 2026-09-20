//
//  WinnerEntry.swift
//  16Tiles
//
//  Created by Alexia Aldea on 20/09/2026.
//

import Foundation
import SwiftData

class WinnerEntry: Codable, Identifiable {
    var id = UUID()
    var username: String
    var imageId: String
    var timeTaken: Int
    var parallelGamesCount: Int
    
    init(id: UUID = UUID(), username: String, imageId: String, timeTaken: Int, parallelGamesCount: Int) {
        self.id = id
        self.username = username
        self.imageId = imageId
        self.timeTaken = timeTaken
        self.parallelGamesCount = parallelGamesCount
    }
}
