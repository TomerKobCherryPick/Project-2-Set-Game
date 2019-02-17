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
    private(set) var score = 0
    private var timeWhenGameStarted = Date.init()
    private(set) var opponentState = OpponentState.waiting
    private(set) var opponentScore = 0
    
    init() {
        createDeck()
        deck.shuffle()
        dealTwelveCards()
        opponentCycle()
    }
    func resetGame() {
        selectedCards =  [Card]()
        cardsOnBoard = [Card]()
        deck = [Card]()
        createDeck()
        deck.shuffle()
        dealTwelveCards()
        selectedCardsMatched = nil
        timeWhenGameStarted = Date.init()
        score = 0
        opponentScore = 0
        opponentCycle()
    }
    public func selectCard(at index: Int) {
        if index < cardsOnBoard.count {
            
            
            let cardToChoose = cardsOnBoard[index]
            // 3 cards are selected
            if selectedCards.count == 3 {
                //if current selected cards are matched replace these cards in cardsOnBoard
                if selectedCardsMatched != nil && selectedCardsMatched! {
                    replaceMatchedCards(chosenCards: selectedCards)
                }
                selectedCards = selectedCards.contains(cardToChoose) ?  [] :[cardToChoose]
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
                        if selectedCardsMatched! {
                            opponentCycle()
                        }
                        score += Int(calculateFactor(isThereAMatch: selectedCardsMatched!))
                    }
                }
            }
        }
    }
    private func calculateFactor(isThereAMatch: Bool) -> Double {
        let timePassedSinceGameStarted = Double (Date.init().timeIntervalSince(timeWhenGameStarted))
        return isThereAMatch ?  2000  / timePassedSinceGameStarted : -100
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
        selectedCardsMatched = false
    }
    private func checkIfSelectedcCardsMatch(cards: Array<Card>) -> Bool {
        var attributesMapsArray = [[Int: Bool](),[Int: Bool](),[Int: Bool](),[Int: Bool]()]
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
            if attributeMap.count  == 2 {
                return false
            }
        }
        return true
    }
    public func checkIfThereIsAMatchOnBoard() -> (Array<Int>?,Bool){
        var possibleMatch: Array<Int>? = nil
        for firstIndex in cardsOnBoard.indices {
            for secondIndex in firstIndex + 1..<cardsOnBoard.count {
                for thirdIndex in secondIndex + 1..<cardsOnBoard.count {
                    if checkIfSelectedcCardsMatch(
                        cards:[cardsOnBoard[firstIndex],
                               cardsOnBoard[secondIndex],
                               cardsOnBoard[thirdIndex]]) {
                        
                        possibleMatch = [firstIndex,
                                         secondIndex,
                                         thirdIndex]
                        return (possibleMatch,true)
                    }
                }
            }
        }
        return (nil,false)
    }
    private func dealTwelveCards() {
        for _ in 0...11{
            cardsOnBoard.append(deck[0])
            deck.remove(at: 0)
        }
    }
    public func dealThreeMoreCards() {
        if checkIfThereIsAMatchOnBoard().1 {
            score -= 50
        }
        if selectedCardsMatched == nil || selectedCardsMatched == false {
            for _ in 0...2 {
                if(deck.count == 0) {
                    break
                }
                cardsOnBoard.append(deck[0])
                deck.remove(at: 0)
            }
        } else {
            replaceMatchedCards(chosenCards: selectedCards)
        }
    }
    private func createDeck(){
        for shape in 0...2 {
            for fill in 0...2 {
                for color in 0...2 {
                    for number in 0...2 {
                        deck.append(Card(shape: shape,fill: fill,color: color, number: number))
                    }
                }
            }
        }
    }
    private func opponentCycle(){
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats:true, block: {_ in
            self.opponentState = OpponentState.readyToMakeAMove
            Timer.scheduledTimer(withTimeInterval: 5.0, repeats:false, block: {_ in
                let possibleMatchIndices = self.checkIfThereIsAMatchOnBoard()
                if possibleMatchIndices.1 {
                    var matched = [Card]()
                    for index in possibleMatchIndices.0!{
                        matched.append(self.cardsOnBoard[index])
                    }
                    self.replaceMatchedCards(chosenCards: matched)
                    self.opponentScore += Int(self.calculateFactor(isThereAMatch: true))
                }
                self.opponentState = OpponentState.waiting
            })
        })
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


