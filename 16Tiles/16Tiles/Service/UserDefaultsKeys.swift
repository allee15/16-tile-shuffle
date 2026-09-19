//
//  UserDefaultsKeys.swift
//  16Tiles
//
//  Created by Alexia Aldea on 19/09/2026.
//

import Foundation

enum UserDefaultsKeys {
    static let ceva = "ceva"
}

public struct Key<T> {
    let value: String
}

class UserDefaultsService {
    static let shared = UserDefaultsService()
    
    private let defaults: UserDefaults
    
    private init() {
        defaults = UserDefaults.standard
    }
    
    func setValue<T>(key: Key<T>, value: Optional<T>) {
        defaults.set(value, forKey: key.value)
    }
    
    func getValue<T>(key: Key<T>) -> Optional<T> {
        return defaults.object(forKey: key.value) as? T
    }
}
