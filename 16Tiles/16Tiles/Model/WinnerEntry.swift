//
//  WinnerEntry.swift
//  16Tiles
//
//  Created by Alexia Aldea on 20/09/2026.
//

import Foundation
import SwiftData

@Model
class WinnerEntry {
    var username: String
    var imageId: String
    var timeTaken: Int
    var parallelGamesCount: Int
    
    init(username: String, imageId: String, timeTaken: Int, parallelGamesCount: Int) {
        self.username = username
        self.imageId = imageId
        self.timeTaken = timeTaken
        self.parallelGamesCount = parallelGamesCount
    }
}
