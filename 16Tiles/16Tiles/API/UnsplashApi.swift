//
//  UnsplashApi.swift
//  16Tiles
//
//  Created by Alexia Aldea on 19/09/2026.
//

import Foundation
import Combine
import SwiftyJSON

class UnsplashApi {
    func getSearchPhotos(query: String, page: Int) -> AnyPublisher<UnsplashPhotoResponse, Error> {
        Future { promise in
            
            var urlComponents = URLComponents(string: "\(DefaultAPIEnvironment.basePath)search/photos")
            urlComponents?.queryItems = [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per_page", value: "5")
            ]
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            
            urlRequest.httpMethod = "GET"
            urlRequest.setValue("Client-ID \(Secrets.unsplashApiKey)", forHTTPHeaderField: "Authorization")
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        let json = try JSON(data: data!)
                        let images = JSONParsers.parseJsonUnsplashResult(json: json)
                        promise(.success(images))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }.eraseToAnyPublisher()
    }
}

enum Secrets {
    static var unsplashApiKey: String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["UnsplashAccessKey"] as? String else {
            fatalError("Secrets.plist missing or UnsplashAccessKey not found")
        }
        return key
    }
}
