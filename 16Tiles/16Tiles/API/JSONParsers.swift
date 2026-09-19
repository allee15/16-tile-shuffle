//
//  JSONParsers.swift
//  16Tiles
//
//  Created by Alexia Aldea on 19/09/2026.
//

import Foundation
import SwiftyJSON

class JSONParsers {
    static func parseJsonUnsplashPhotos(json: JSON) -> [UnsplashPhoto] {
        return json.arrayValue.map({ parseJsonPhoto(json: $0) })
    }
    
    static func parseJsonPhoto(json: JSON) -> UnsplashPhoto {
        let urls = UnsplashUrl(regular: json["urls"]["regular"].stringValue,
                               full: json["urls"]["full"].stringValue)
        
        return UnsplashPhoto(id: json["id"].stringValue,
                             title: json["description"].stringValue,
                             artistName: json["user"]["name"].stringValue,
                             urls: urls)
    }
    
    static func parseJsonUnsplashResult(json: JSON) -> UnsplashPhotoResponse {
        return UnsplashPhotoResponse(totalImages: json["total"].intValue,
                                     totalPages: json["total_pages"].intValue,
                                     results: parseJsonUnsplashPhotos(json: json["results"]))
    }
}
