//
//  Fill.swift
//  SetGame
//
//  Created by Tomer Kobrinsky on 18/02/2019.
//  Copyright © 2019 Tomer Kobrinsky. All rights reserved.
//

import Foundation
import UIKit

enum Fill: Int {
    case stripe  = 0
    case filled = 1
    case outlined = 2
    
    static func convertToNSAttributedStringKeys(fillType: Fill, color: UIColor) -> [NSAttributedString.Key:Any] {
        switch fillType {
        case .stripe:
            return [.foregroundColor: color.withAlphaComponent(0.15)]
        case .filled:
            return [.foregroundColor: color.withAlphaComponent(1)]
        case .outlined:
            return [.foregroundColor: color, .strokeWidth: 8.0]
        }
        
    }
}
