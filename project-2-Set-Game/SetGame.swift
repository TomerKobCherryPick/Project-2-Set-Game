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
    private(set) var opponentState = OpponentState.notWaitingForTurn
    private(set) var opponentScore = 0
    private(set) var isGameOver = false
    private var opponentCycleTimer,opponentWaitTimer, opponentReadyToMakeAMoveTimer , opponentMakesAMoveTimer, opponentDoesntWaitForTurnTimer : Timer?
    
    private var timeCycle = 0
    weak var delegate: SetGameDelegate?
    init() {
        resetDeckAndBoard()
        setOppnentTimer()
    }
    func resetGame() {
        isGameOver = false
        selectedCards =  [Card]()
        cardsOnBoard = [Card]()
        deck = [Card]()
        resetDeckAndBoard()
        selectedCardsMatched = nil
        timeWhenGameStarted = Date.init()
        score = 0
        opponentScore = 0
        opponentState = OpponentState.notWaitingForTurn
        self.delegate?.setOpponentState(data:  self.opponentState)
        stopTimers()
        setOppnentTimer()
    }
    private func resetDeckAndBoard(){
        createDeck()
        deck.shuffle()
        dealMoreCards(cardsToDeal: 12)
    }
    
    public func selectCard(at index: Int) {
        if index < cardsOnBoard.count && !isGameOver {
            let cardToChoose = cardsOnBoard[index]
            // 3 cards are selected
            if selectedCards.count == 3 {
                opponentState = OpponentState.notWaitingForTurn
                delegate?.setOpponentState(data: opponentState)
                self.setOppnentTimer()
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
                    // if after selecting a card, there are 3 selected cards,
                    // we check whether selected cards match
                    if selectedCards.count == 3 {
                        selectedCardsMatched = checkIfSelectedcCardsMatch(cards: selectedCards)
                        if !isGameOver {
                            score += Int(calculateFactor(isThereAMatch: selectedCardsMatched!))
                        }
                        if selectedCardsMatched! {
                            stopTimers()
                            opponentLostRound()
                        }
                    }
                }
            }
        }
        checkIfThereIsAMatchOnBoard()
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
    public func checkIfThereIsAMatchOnBoard() -> (arrayOfMatchedCards: Array<Int>?,isMatched: Bool){
        var possibleMatch: Array<Int>? = nil
        for firstIndex in cardsOnBoard.indices {
            for secondIndex in firstIndex + 1..<cardsOnBoard.count {
                for thirdIndex in secondIndex + 1..<cardsOnBoard.count {
                    if checkIfSelectedcCardsMatch(
                        cards:[cardsOnBoard[firstIndex],
                               cardsOnBoard[secondIndex],
                               cardsOnBoard[thirdIndex]]) {
                        possibleMatch = [firstIndex,secondIndex,thirdIndex]
                        return (possibleMatch,true)
                    }
                }
            }
        }
        if deck.count == 0 {
            gameOver()
        }
        return (nil,false)
    }
    private func dealMoreCards(cardsToDeal: Int) {
        dealCardLoop: for _ in 1...cardsToDeal{
            if deck.count == 0 || cardsOnBoard.count == 24 {
                break dealCardLoop
            }
            cardsOnBoard.append(deck[0])
            deck.remove(at: 0)
        }
    }
    public func dealThreeMoreCards() {
        if checkIfThereIsAMatchOnBoard().isMatched {
            score -= 50
        }
        if selectedCardsMatched != true {
            dealMoreCards(cardsToDeal: 3)
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
    private func setOppnentTimer() {
        opponentCycleTimer = Timer.scheduledTimer(withTimeInterval: 14, repeats: true, block: {_ in
            self.opponentWaitTimer = Timer.scheduledTimer(withTimeInterval: 0, repeats: false, block: {_ in
                //opponent is waiting
                self.opponentState = OpponentState.waiting
                self.delegate?.setOpponentState(data:  self.opponentState)
            })
            self.opponentReadyToMakeAMoveTimer = Timer.scheduledTimer(withTimeInterval: 6, repeats: false, block: {_ in
                //opponent is ready
                self.opponentState = OpponentState.readyToMakeAMove
                self.delegate?.setOpponentState(data:  self.opponentState)
            })
            self.opponentMakesAMoveTimer = Timer.scheduledTimer(withTimeInterval: 9, repeats: false, block: {_ in
               //opponent makes a move
                let possibleMatchIndices = self.checkIfThereIsAMatchOnBoard()
                //opponent found a match
                if possibleMatchIndices.isMatched {
                    self.opponentFoundAMatchActions(matchIndices: possibleMatchIndices.arrayOfMatchedCards!)
                    self.opponentState = OpponentState.wonRound
                    self.delegate?.setOpponentState(data:  self.opponentState)
                    self.delegate?.macthedIndicesIfExist(match: possibleMatchIndices.arrayOfMatchedCards!)
                }
                //if there are no more matches then game is over & no cards in the deck
                let isThereANextMatch = self.checkIfThereIsAMatchOnBoard().isMatched
                if self.deck.count == 0 && isThereANextMatch == false  {
                    self.gameOver()
                }
            })
            self.opponentDoesntWaitForTurnTimer = Timer.scheduledTimer(withTimeInterval: 12, repeats: false, block:
                {_ in
                //opponent is done making a move
                    self.opponentState = OpponentState.notWaitingForTurn
                    self.delegate?.setOpponentState(data:  self.opponentState)
            })
        })
    }
    private func stopTimers() {
        opponentCycleTimer?.invalidate()
        opponentCycleTimer?.invalidate()
        opponentWaitTimer?.invalidate()
        opponentDoesntWaitForTurnTimer?.invalidate()
        opponentReadyToMakeAMoveTimer?.invalidate()
        opponentMakesAMoveTimer?.invalidate()
        opponentDoesntWaitForTurnTimer?.invalidate()
    }
    private func opponentLostRound() {
        self.opponentState = OpponentState.lostRound
        self.delegate?.setOpponentState(data:  self.opponentState)
    }
    private func gameOver() {
        stopTimers()
        isGameOver = true
        opponentState =  score > opponentScore ?
        OpponentState.lost : OpponentState.won
        delegate?.setOpponentState(data:  opponentState)
        delegate?.gameOver()
    }
    private func opponentFoundAMatchActions(matchIndices: Array<Int>) {
        var matched = [Card]()
        for index in matchIndices {
            matched.append(self.cardsOnBoard[index])
            if let indexToRemove = self.selectedCards.firstIndex(of: self.cardsOnBoard[index]) {
                self.selectedCards.remove(at: indexToRemove)
            }
        }
        self.replaceMatchedCards(chosenCards: matched)
        self.opponentScore += Int(self.calculateFactor(isThereAMatch: true))
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
        self.dealMoreCards(cardsToDeal: 12)
    }
    func checkIfSelectedcCardsMatchTest(cards: Array<Card>) -> Bool {
        return self.checkIfSelectedcCardsMatch(cards: cards)
    }
    func replaceMatchedCardsTest(chosenCards: Array<Card>) {
        return self.replaceMatchedCards(chosenCards: chosenCards)
    }
}
#endif


