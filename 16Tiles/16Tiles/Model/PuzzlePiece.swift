//
//  PuzzlePiece.swift
//  16Tiles
//
//  Created by Alexia Aldea on 20/09/2026.
//

import Foundation
import SwiftUI

struct PuzzlePiece: Identifiable {
    var id = UUID()
    var image: Image
    var pieceIndex: Int
}
