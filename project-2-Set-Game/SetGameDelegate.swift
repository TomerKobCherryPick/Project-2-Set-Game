//
//  setGameDelegate.swift
//  SetGame
//
//  Created by Tomer Kobrinsky on 19/02/2019.
//  Copyright © 2019 Tomer Kobrinsky. All rights reserved.
//

import Foundation

protocol SetGameDelegate: class {
    func setOpponentState(data: OpponentState)
    func macthedIndicesIfExist(match: Array<Int>?)
    func gameOver()
}
