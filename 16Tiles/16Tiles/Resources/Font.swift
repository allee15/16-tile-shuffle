//
//  Font.swift
//  16Tiles
//
//  Created by Alexia Aldea on 19/09/2026.
//

import Foundation
import SwiftUI

extension Font {
    static func bold(size: CGFloat) -> Font {
        return Font.system(size: size, weight: .bold)
    }
    
    static func regular(size: CGFloat) -> Font {
        return Font.system(size: size, weight: .regular)
    }
        
    static func semiBold(size: CGFloat) -> Font {
        return Font.system(size: size, weight: .semibold)
    }
    
    static func light(size: CGFloat) -> Font {
        return Font.system(size: size, weight: .light)
    }
    
    static func medium(size: CGFloat) -> Font {
        return Font.system(size: size, weight: .medium)
    }
}
