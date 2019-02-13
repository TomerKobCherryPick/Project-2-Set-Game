//
//  Card.swift
//  project-2-Set-Game
//
//  Created by Tomer Kobrinsky on 13/02/2019.
//  Copyright © 2019 Tomer Kobrinsky. All rights reserved.
//

import Foundation

struct Card {
    private let shape: Int
    private let fill: Int
    private let color: Int
    private let number: Int
    init(shape: Int, fill: Int, color: Int, number: Int){
        self.shape = shape
        self.fill = fill
        self.color = color
        self.number = number
    }
}


