//
//  BaseViewModel.swift
//  16Tiles
//
//  Created by Alexia Aldea on 19/09/2026.
//


import Foundation
import Combine

class BaseViewModel: ObservableObject {
    var bag = Set<AnyCancellable>()
}
