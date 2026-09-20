//
//  GameSession.swift
//  16Tiles
//
//  Created by Alexia Aldea on 20/09/2026.
//

import Foundation

class GameSession: Codable, Identifiable {
    var id: String {imageId}
    
    var imageId: String
    var imageUrl: String
    var gridSize: Int
    var tilesState: [Int]
    var remainingSeconds: Int
    
    init(imageId: String, imageUrl: String, gridSize: Int, tilesState: [Int], remainingSeconds: Int) {
        self.imageId = imageId
        self.imageUrl = imageUrl
        self.gridSize = gridSize
        self.tilesState = tilesState
        self.remainingSeconds = remainingSeconds
    }
}
