//
//  UnsplashPhoto.swift
//  16Tiles
//
//  Created by Alexia Aldea on 19/09/2026.
//

import Foundation

struct UnsplashPhotoResponse {
    let totalImages: Int
    let totalPages: Int
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto {
    let id: String
    let title: String
    let artistName: String
    let urls: UnsplashUrl
}

struct UnsplashUrl {
    let regular: String
    let full: String
}
