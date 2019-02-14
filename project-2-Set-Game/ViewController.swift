//
//  ViewController.swift
//  project-2-Set-Game
//
//  Created by Tomer Kobrinsky on 12/02/2019.
//  Copyright © 2019 Tomer Kobrinsky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let intToShapeMap = [0: "▲", 1: "●", 2: "■"]
    private let intToColorMap = [0: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) , 1: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1) , 2: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)]
    private let intToFillMap = [0: Fill.stripe, 1: Fill.filled, 2: Fill.outlined ]
    
    private lazy var game = SetGame()
    @IBOutlet weak var dealthreeCardsButton: UIButton!
    @IBOutlet var nonVisibleCardButtons: [UIButton]!
    @IBOutlet var visibleCardButtons: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in nonVisibleCardButtons {
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            button.layer.cornerRadius = 8.0
        }
        for index in visibleCardButtons.indices {
            visibleCardButtons[index].layer.cornerRadius = 8.0
            setTextInCard(button: visibleCardButtons[index], card: game.cardsOnBoard[index])
        }
        
    }
    private func setTextInCard(button: UIButton, card: Card) {
        var shape = intToShapeMap[card.attributes[0]]!
        let color = intToColorMap[card.attributes[1]]!
        let fill = intToFillMap[card.attributes[2]]!
        for _ in 0..<card.attributes[3] {
            shape += intToShapeMap[card.attributes[0]]!
        }
        let attributedString = NSAttributedString(string: shape, attributes: Fill.convertToNSAttributedStringKeys(fillType: fill, color: color))
        button.setAttributedTitle(attributedString, for: UIControl.State.normal)
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if visibleCardButtons.contains(sender) {
            game.selectCard(at: visibleCardButtons.index(of: sender)!)
            sender.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.3732074058)
        } else {
            print("chosen card wasn't in CardButtons")
        }
    }
    @IBAction func touchNewGame(_ sender: Any) {
        game.resetGame()
        var newNonVisiblebuttons = [UIButton]()
        while visibleCardButtons.count > 12 {
            let buttonToMove = visibleCardButtons.remove(at: 12)
            newNonVisiblebuttons.append(buttonToMove)
            buttonToMove.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            let attributedString = NSAttributedString(string: "", attributes: [:])
            buttonToMove.setAttributedTitle(attributedString, for: UIControl.State.normal)
        }
        for index in visibleCardButtons.indices {
            visibleCardButtons[index].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            setTextInCard(button: visibleCardButtons[index], card: game.cardsOnBoard[index])
        }
        for button in nonVisibleCardButtons {
            newNonVisiblebuttons.append(button)
        }
        nonVisibleCardButtons = newNonVisiblebuttons
        dealthreeCardsButton.setTitle("Deal 3 more Cards", for: UIControl.State.normal)
    }
    
    @IBAction func touchDealThreeMoreCards(_ sender: Any) {
        game.dealThreeMoreCards()
        //TODO: add condition for setgame if there is a match
        for _ in 0...2 {
            if visibleCardButtons.count < 24 {
                let lastCardIndex: Int
                visibleCardButtons.append(nonVisibleCardButtons.remove(at: 0))
                lastCardIndex = visibleCardButtons.count - 1
                visibleCardButtons[lastCardIndex].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                setTextInCard(button: visibleCardButtons[lastCardIndex], card: game.cardsOnBoard[lastCardIndex])
            } else {
                break
            }
        }
        if visibleCardButtons.count == 24 {
            dealthreeCardsButton.setTitle("", for: UIControl.State.normal)
        }
    }
    
}

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
            return [.strokeWidth: 8.0]
        }
        
    }
}

