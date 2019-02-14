//
//  SetGame.swift
//  project-2-Set-Game
//
//  Created by Tomer Kobrinsky on 13/02/2019.
//  Copyright © 2019 Tomer Kobrinsky. All rights reserved.
//

import Foundation

class SetGame {
    private(set) var selectedCards = [Card]()
    private(set) var deck = [Card]()
    private(set) var cardsOnBoard = [Card]()
    private(set) var selectedCardsMatched: Bool?
    init() {
        createDeck()
        deck.shuffle()
        dealTwelveCards()
    }
    public func selectCard(at index: Int) {
        let cardToChoose = cardsOnBoard[index]
        // 3 cards are selected
        if selectedCards.count == 3 {
            //if current selected cards are matched replace these cards in cardsOnBoard
            if selectedCardsMatched != nil && selectedCardsMatched! {
                replaceMatchedCards(chosenCards: selectedCards)
            }
            if !selectedCards.contains(cardToChoose) {
                selectedCards = [cardToChoose]
            } else {
                selectedCards = []
            }
            selectedCardsMatched = false
        }
        // 1 or 2 crads are selected
        else {
            // if the card we are trying to select is already selected, we deselect it
            if let index = selectedCards.firstIndex(of: cardToChoose){
                selectedCards.remove(at: index)
            }
            // else, we add the card to selected cards
            else {
                selectedCards.append(cardToChoose)
                // if after selecting a crad, there are 3 selected cards,
                // we check wether selected cards match
                if(selectedCards.count == 3) {
                    selectedCardsMatched = checkIfSelectedcCardsMatch(cards: selectedCards)
                }
            }
        }
    }
    private func replaceMatchedCards(chosenCards: Array<Card>){
        for card in chosenCards {
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
    private func checkIfSelectedcCardsMatch(cards: Array<Card>) -> Bool {
        var attributesMapsArray = [
            [Int: Bool](),
            [Int: Bool](),
            [Int: Bool](),
            [Int: Bool]()
        ]
        for card in cards {
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
        selectedCardsMatched = nil
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
#if DEBUG
extension SetGame {
    func setDeck(newDeck: [Card]){
        self.deck = newDeck
    }
    func setCardsOnBoard(newCardsOnBoard: [Card]){
        self.cardsOnBoard = newCardsOnBoard
    }
    func setSelectedCards(newSelectedCards: [Card]){
        self.selectedCards = newSelectedCards
    }
    func createNonShuffledDeckForTest() {
        deck = []
        self.createDeck()
    }
    func dealTwelveCardsForTest() {
        self.dealTwelveCards()
    }
    func checkIfSelectedcCardsMatchTest(cards: Array<Card>) -> Bool {
        return self.checkIfSelectedcCardsMatch(cards: cards)
    }
    func replaceMatchedCardsTest(chosenCards: Array<Card>) {
        return self.replaceMatchedCards(chosenCards: chosenCards)
    }
}
#endif


