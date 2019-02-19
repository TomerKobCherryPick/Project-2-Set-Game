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
    private let intToColorMap = [0: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1) , 1: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1) , 2: #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1)]
    private let intToFillMap = [0: Fill.stripe, 1: Fill.filled, 2: Fill.outlined]
    private lazy var game = SetGame()
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var dealthreeCardsButton: UIButton!
    @IBOutlet var nonVisibleCardButtons: [UIButton]!
    @IBOutlet var visibleCardButtons: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var cheatButton: UIButton!
    @IBOutlet weak var iphoneScoreLabel: UILabel!
    @IBOutlet weak var whoWonLabel: UILabel!
    var opponentState: String {
        get {
            return game.opponentState.stateToEmoji()
        } set(newValue) {
            iphoneScoreLabel.text = "\(newValue) iphone's Score: \(game.opponentScore)"
        }
    }
    private var whoWonString: String {
        return game.score == game.opponentScore ? "It's a tie 🤨" :
            game.score > game.opponentScore ? "You Won 😃" : "You Lost 😩"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        game.delegate = self
        dealthreeCardsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        newGameButton.titleLabel?.adjustsFontSizeToFitWidth = true
        cheatButton.titleLabel?.adjustsFontSizeToFitWidth = true
        scoreLabel.adjustsFontSizeToFitWidth = true
        iphoneScoreLabel.adjustsFontSizeToFitWidth = true
        whoWonLabel.adjustsFontSizeToFitWidth = true
        whoWonLabel.text = ""
        iphoneScoreLabel.text = "\(opponentState) iphone's Score: \(game.opponentScore)"
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
        } else {
            print("chosen card wasn't in visibleCardButtons")
        }
        updateViewFromModel()
    }
    @IBAction func touchNewGame(_ sender: Any) {
        game.resetGame()
        var newNonVisiblebuttons = [UIButton]()
        while visibleCardButtons.count > 12 {
            let buttonToMove = visibleCardButtons.remove(at: 12)
            newNonVisiblebuttons.append(buttonToMove)
            clearViewForButton(button: buttonToMove)
        }
        updateViewFromModel()
        for button in nonVisibleCardButtons {
            newNonVisiblebuttons.append(button)
        }
        nonVisibleCardButtons = newNonVisiblebuttons
        dealthreeCardsButton.setTitle("Deal 3 more Cards", for: UIControl.State.normal)
        cheatButton.setTitle("Cheat", for: UIControl.State.normal)
        whoWonLabel.text = ""
    }
    @IBAction func touchDealThreeMoreCards(_ sender: Any) {
        let cardsSelectedMatch = game.selectedCardsMatched
        game.dealThreeMoreCards()
        if cardsSelectedMatch == nil || cardsSelectedMatch == false {
            for _ in 0...2 {
                if visibleCardButtons.count < 24 {
                    visibleCardButtons.append(nonVisibleCardButtons.remove(at: 0))
                } else {
                    break
                }
            }
        }
        updateViewFromModel()
        if visibleCardButtons.count == 24 || game.deck.count == 0 {
            dealthreeCardsButton.setTitle("", for: UIControl.State.normal)
        }
    }
    @IBAction func touchCheat(_ sender: Any) {
        updateViewFromModel()
        let possibleMatch =  game.checkIfThereIsAMatchOnBoard()
        if possibleMatch.isMatched {
            visibleCardButtons[possibleMatch.arrayOfMatchedCards![0]].backgroundColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
            visibleCardButtons[possibleMatch.arrayOfMatchedCards![1]].backgroundColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
            visibleCardButtons[possibleMatch.arrayOfMatchedCards![2]].backgroundColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
        }
    }
    private func updateViewFromModel(){
       scoreLabel.text = "Score: \(game.score)"
        for index in visibleCardButtons.indices {
            updateViewForCard(index: index)
        }
    }
    private func updateViewForCard(index: Int) {
        if index < game.cardsOnBoard.count {
            let card = game.cardsOnBoard[index]
            if !game.selectedCards.contains(card) {
                visibleCardButtons[index].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                visibleCardButtons[index].backgroundColor = game.selectedCards.count == 3 ?
                    game.selectedCardsMatched! ? #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1) : #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                    :#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.3732074058)
            }
            setTextInCard(button: visibleCardButtons[index], card: game.cardsOnBoard[index])
        } else {
            clearViewForButton(button: visibleCardButtons[index])
        }
    }
    private func clearViewForButton(button: UIButton) {
        button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
        let attributedString = NSAttributedString(string: "", attributes: [:])
        button.setAttributedTitle(attributedString, for: UIControl.State.normal)
    }
}
extension ViewController: SetGameDelegate {
    func gameOver() {
        whoWonLabel.text = "\(whoWonString)"
        cheatButton.setTitle("", for: UIControl.State.normal)
        dealthreeCardsButton.setTitle("", for: UIControl.State.normal)
    }
    
    func macthedIndicesIfExist(match: Array<Int>?) {
        if match != nil {
            for index in match! {
                visibleCardButtons[index].backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            }
            for button in visibleCardButtons {
                button.isEnabled = false
            }
            Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(selector), userInfo: nil, repeats: false)
        }
        
    }
    @objc private func selector() {
        updateViewFromModel()
        for button in visibleCardButtons {
            button.isEnabled = true
        }
    }
    
    func setOpponentState(data: OpponentState) {
        opponentState = data.stateToEmoji()
    }
    
    
    
}


