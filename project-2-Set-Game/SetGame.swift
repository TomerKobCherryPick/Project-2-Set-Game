//
//  SetGame.swift
//  project-2-Set-Game
//
//  Created by Tomer Kobrinsky on 13/02/2019.
//  Copyright © 2019 Tomer Kobrinsky. All rights reserved.
//

import Foundation

class SetGame {
    private var selectedCards = [Card]()
    private var deck = [Card]()
    private var cardsOnBoard = [Card]()
    private var selectedCardsMatched = false
    init() {
        createDeck()
        deck.shuffle()
        dealTwelveCards()
    }
    private func selectCard(at index: Int) {
        if selectedCards.count == 3 {
            if selectedCardsMatched {
                replaceMatchedCards()
            }
            selectedCards = []
            selectedCardsMatched = false
            selectedCards.append(cardsOnBoard[index])
        } else {
            if let index = selectedCards.firstIndex(of: cardsOnBoard[index]){
                selectedCards.remove(at: index)
            } else {
                selectedCards.append(cardsOnBoard[index])
                if(selectedCards.count == 3) {
                    selectedCardsMatched = checkIfSelectedcCardsMatch()
                }
            }
        }
    }
    private func replaceMatchedCards(){
        for card in selectedCards {
            if let indexOfCard = cardsOnBoard.index(of: card) {
                // if there are more cards in the deck
                if deck.count > 0 {
                    let newCard = deck.remove(at: 0)
                    cardsOnBoard[indexOfCard] = newCard
                } else {
                    cardsOnBoard.remove(at: indexOfCard)
                }
            }
        }
    }
    private func checkIfSelectedcCardsMatch() -> Bool {
        var attributesMapsArray = [
            [Int: Bool](),
            [Int: Bool](),
            [Int: Bool](),
            [Int: Bool]()
        ]
        for card in selectedCards {
            var attributeType = 0
            for attribute in card.attributes {
                if attributesMapsArray[attributeType][attribute] == nil {
                    attributesMapsArray[attributeType][attribute] = true
                }
                attributeType += 1
            }
        }
        for attributeMap in attributesMapsArray {
            if attributeMap.count == 2 {
                return false
            }
        }
        return true
    }
    private func dealTwelveCards() {
        for _ in 0...3{
            dealThreeMoreCards()
        }
    }
    private func dealThreeMoreCards() {
        for _ in 0...2 {
            cardsOnBoard.append(deck[0])
            deck.remove(at: 0)
        }
    }
    private func resetGame() {
        selectedCards =  [Card]()
        cardsOnBoard = [Card]()
        deck = [Card]()
        createDeck()
        deck.shuffle()
        dealTwelveCards()
        selectedCardsMatched = false
    }
    private func createDeck(){
        for shape in 0...2 {
            for fill in 0...2 {
                for color in 0...2 {
                    for number in 0...2 {
                        deck.append(
                            Card(shape: shape,
                                 fill: fill,
                                 color: color,
                                 number: number)
                        )
                    }
                }
            }
        }
    }
}

