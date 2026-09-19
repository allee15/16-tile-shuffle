//
//  UnsplashService.swift
//  16Tiles
//
//  Created by Alexia Aldea on 19/09/2026.
//

import Foundation
import Combine

class UnsplashService {
    static let shared = UnsplashService()
    private let unsplashApi = UnsplashApi()
    var bag = Set<AnyCancellable>()
    
    private init() { }
}
