//
//  PuzzleView.swift
//  16Tiles
//
//  Created by Alexia Aldea on 20/09/2026.
//

import SwiftUI
import Kingfisher

struct PuzzlePiece: Identifiable {
    var id = UUID()
    var image: Image
    var pieceIndex: Int
}

struct PuzzleView: View {
    @State private var pieces: [PuzzlePiece?] = []
    @State private var isCompleted: Bool = false
    
    var imageUrlString: String
    var gridSize: Int
    
    var body: some View {
        GeometryReader { geo in
            let availableWidth = geo.size.width - 40
            let pieceSize = availableWidth / CGFloat(gridSize)
            let puzzleAreaSize = pieceSize * CGFloat(gridSize)
            
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .strokeBorder(Color.textSecondary.opacity(0.5), lineWidth: 2)
                    .frame(width: puzzleAreaSize, height: puzzleAreaSize)
                    .position(x: geo.size.width / 2,
                              y: geo.size.height / 2)
                
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(pieceSize), spacing: 0), count: gridSize), spacing: 0) {
                    ForEach(0..<pieces.count, id: \.self) { index in
                        if let piece = pieces[index] {
                            PuzzlePieceView(piece: piece, pieceSize: pieceSize) {
                                tapPiece(at: index)
                            }
                        } else {
                            Color.clear
                                .frame(width: pieceSize, height: pieceSize)
                        }
                    }
                }
                .frame(width: puzzleAreaSize, height: puzzleAreaSize)
                .position(x: geo.size.width / 2, y: geo.size.height / 2)
            }
            .onAppear {
                setupPuzzle(imageURL: URL(string: imageUrlString)!, screenSize: geo.size, pieceSize: pieceSize)
            }
        }
    }
    
    func setupPuzzle(imageURL: URL, screenSize: CGSize, pieceSize: CGFloat) {
        KingfisherManager.shared.retrieveImage(with: imageURL) { result in
            switch result {
            case .success(let value):
                DispatchQueue.main.async {
                    let images = splitImageIntoPieces(image: value.image, gridSize: gridSize)
                    buildPieces(from: images)
                }
            case .failure(let error):
                print("Failed to download puzzle image: \(error)")
            }
        }
    }
    
    func buildPieces(from images: [UIImage]) {
        var newPieces: [PuzzlePiece?] = images.enumerated().map { index, image in
            PuzzlePiece(image: Image(uiImage: image), pieceIndex: index)
        }
        
        newPieces[newPieces.count - 1] = nil
        pieces = newPieces
        
        shuffle()
    }
    
    func shuffle(moves: Int = 200) {
        for _ in 0..<moves {
            let empty = pieces.firstIndex(where: { $0 == nil })!
            let candidates = adjacentIndices(of: empty)
            if let random = candidates.randomElement() {
                pieces.swapAt(empty, random)
            }
        }
    }
    
    func tapPiece(at index: Int) {
        guard let empty = pieces.firstIndex(where: { $0 == nil }) else { return }
        guard isAdjacent(index, empty) else {return}
        
        pieces.swapAt(index, empty)
        
        checkIfSolved()
    }
    
    func checkIfSolved() {
        for i in 0..<(pieces.count - 1) {
            guard let piece = pieces[i], piece.pieceIndex == i else {return}
        }
        
        isCompleted = true
    }
    
    func isAdjacent(_ a: Int, _ b: Int) -> Bool {
        let rowA = a / gridSize
        let colA = a % gridSize
        
        let rowB = b / gridSize
        let colB = b % gridSize
        
        return (abs(rowA - rowB) == 1 && colA == colB) ||
                (abs(colA - colB) == 1 && rowA == rowB)
    }
    
    func adjacentIndices(of index: Int) -> [Int] {
        let row = index / gridSize
        let col = index % gridSize
        
        var result: [Int] = []
        if row > 0 { result.append(index - gridSize) }
        if row < gridSize - 1 { result.append(index + gridSize) }
        if col > 0 { result.append(index - 1) }
        if col < gridSize - 1 { result.append(index + 1) }
        return result
    }
    
    func splitImageIntoPieces(image: UIImage, gridSize: Int) -> [UIImage] {
        guard let cgImage = image.cgImage else { return [] }
        
        let width = cgImage.width
        let height = cgImage.height
        let pieceWidth = width / gridSize
        let pieceHeight = height / gridSize
        
        var pieces: [UIImage] = []
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let rect = CGRect(
                    x: col * pieceWidth,
                    y: row * pieceHeight,
                    width: pieceWidth,
                    height: pieceHeight
                )
                if let cropped = cgImage.cropping(to: rect) {
                    pieces.append(UIImage(cgImage: cropped))
                }
            }
        }
        return pieces
    }
}

struct PuzzlePieceView: View {
    let piece: PuzzlePiece
    let pieceSize: CGFloat
    let tapPiece: () -> ()
    
    var body: some View {
        piece.image
            .resizable()
            .frame(width: pieceSize, height: pieceSize)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    tapPiece()
                }
            }
    }
}
