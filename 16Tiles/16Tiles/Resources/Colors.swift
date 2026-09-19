//
//  Colors.swift
//  16Tiles
//
//  Created by Alexia Aldea on 19/09/2026.
//

import Foundation
import SwiftUI

extension Color {
    // Raw palette
    static let creamPrimary = Color(hex: "#fcf1ef")
    static let creamSecondary = Color(hex: "#e8d8c9")
    static let grayDarkerPrimary = Color(hex: "#5e606c")
    static let pinkPrimary = Color(hex: "#e4babe")
    static let pinkPrimaryDark = Color(hex: "#c98d93")
    
    static let successGreen = Color(hex: "#A8C3A0")
    static let dangerRed = Color(hex: "#D98C88")
    
    // Semantic roles
    static let backgroundPrimary = Color.creamPrimary
    static let backgroundSecondary = Color.creamSecondary

    static let textPrimary = Color.grayDarkerPrimary
    static let textSecondary = Color.grayDarkerPrimary.opacity(0.6)

    static let accent = Color.pinkPrimary
    static let accentButton = Color.pinkPrimaryDark

    static let success = Color.successGreen
    static let danger = Color.dangerRed
}

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            self.init(red: 0, green: 0, blue: 0, opacity: 0)
            return
        }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            self.init(red: 0, green: 0, blue: 0, opacity: 0)
        }
        
        self.init(red: r, green: g, blue: b, opacity: a)
    }
}
