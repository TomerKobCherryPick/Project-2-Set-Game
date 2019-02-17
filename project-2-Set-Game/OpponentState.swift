//
//  OpponentState.swift
//  SetGame
//
//  Created by Tomer Kobrinsky on 17/02/2019.
//  Copyright © 2019 Tomer Kobrinsky. All rights reserved.
//

import Foundation
enum OpponentState {
    case waiting, readyToMakeAMove, won, lost
    func stateToEmoji() -> String {
        switch self {
        case .waiting: return "🤔"
        case .readyToMakeAMove:  return "😁"
        case .won: return "😂"
        case .lost: return "😢"
        }
    }
}
