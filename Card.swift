//
//  Card.swift
//  project-2-Set-Game
//
//  Created by Tomer Kobrinsky on 13/02/2019.
//  Copyright © 2019 Tomer Kobrinsky. All rights reserved.
//

import Foundation

struct Card {
    private let identifier: Int
    private static var identifierFactory = 0
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
    
}
extension Card: Hashable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    var hashValue: Int {
        return identifier
    }
}
