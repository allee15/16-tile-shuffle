//
//  Router.swift
//  16Tiles
//
//  Created by Alexia Aldea on 20/09/2026.
//

import Foundation
import SwiftUI
import Combine

enum Route: Hashable {
    case menu
    case imageDetails(UnsplashPhoto)
    case ranking
    case activeGames
}

class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else {return}
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}
