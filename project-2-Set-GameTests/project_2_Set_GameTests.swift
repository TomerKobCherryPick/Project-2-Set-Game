//
//  project_2_Set_GameTests.swift
//  project-2-Set-GameTests
//
//  Created by Tomer Kobrinsky on 14/02/2019.
//  Copyright © 2019 Tomer Kobrinsky. All rights reserved.
//

import XCTest
@testable import SetGame

class project_2_Set_GameTests: XCTestCase {
    
    let game = SetGame()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testMatchingCardsByDifferentAttributes() {
        let card1 = Card(shape: 0, fill: 0, color: 0, number: 0)
        let card2 = Card(shape: 1, fill: 1, color: 1, number: 1)
        let card3 = Card(shape: 2, fill: 2, color: 2, number: 2)
        XCTAssertTrue(game.checkIfSelectedcCardsMatch(cards: [card1, card2, card3]))
    }
    
    func testMatchingCardsBySameAttributes() {
        let card1 = Card(shape: 0, fill: 1, color: 2, number: 0)
        let card2 = Card(shape: 0, fill: 1, color: 2, number: 1)
        let card3 = Card(shape: 0, fill: 1, color: 2, number: 2)
        XCTAssertTrue(game.checkIfSelectedcCardsMatch(cards: [card1, card2, card3]))
    }
    
    func testNonMatchingCards() {
        let card1 = Card(shape: 1, fill: 1, color: 2, number: 0)
        let card2 = Card(shape: 0, fill: 1, color: 2, number: 1)
        let card3 = Card(shape: 0, fill: 1, color: 2, number: 2)
        XCTAssertFalse(game.checkIfSelectedcCardsMatch(cards: [card1, card2, card3]))
    }
    
    func testReplaceMatchedCardsWhenDeckIsNotEmpty() {
        let chosenCards = [
            game.cardsOnBoard[0],
            game.cardsOnBoard[1],
            game.cardsOnBoard[2]
        ]
        game.replaceMatchedCards(chosenCards: chosenCards)
        let cardsAfterReplacement = [game.cardsOnBoard[0],
                                     game.cardsOnBoard[1],
                                     game.cardsOnBoard[2]
        ]
        XCTAssertFalse(chosenCards.elementsEqual(cardsAfterReplacement))
    }
    
    func testReplaceMatchedCardsWhenDeckIsEmpty() {
        var chosenCards:Array<Card>
        game.setDeck(newDeck: [])
        chosenCards = [
            game.cardsOnBoard[0],
            game.cardsOnBoard[1],
            game.cardsOnBoard[2]
        ]
        game.replaceMatchedCards(chosenCards: chosenCards)
        XCTAssertFalse(
            game.cardsOnBoard.contains(chosenCards[0]) ||
            game.cardsOnBoard.contains(chosenCards[1]) ||
            game.cardsOnBoard.contains(chosenCards[2])
        )
    }
    
    func testSelectCardWhenNoCardsAreSelected() {
        let cardToselect = game.cardsOnBoard[0]
        game.selectCard(at: 0)
        XCTAssertTrue(game.selectedCards[0] == cardToselect)
    }
    
    func testSelectCardWhenOneCardsIsSelected() {
        let cardToSelect = [
            game.cardsOnBoard[0],
            game.cardsOnBoard[1]
        ]
        game.selectCard(at: 0)
        game.selectCard(at: 1)
        XCTAssertTrue(game.selectedCards.elementsEqual(cardToSelect))
    }
    func testSelectCardWhenTwoCardsAreSelectedAndMatch() {
        var cardToSelect: [Card]
        game.createNonShuffledDeckForTest()
        game.setCardsOnBoard(newCardsOnBoard: [])
        game.dealTwelveCardsForTest()
        
        cardToSelect = [
            game.cardsOnBoard[0],
            game.cardsOnBoard[1],
            game.cardsOnBoard[2]
        ]
        game.selectCard(at: 0)
        game.selectCard(at: 1)
        game.selectCard(at: 2)
        XCTAssertTrue(game.selectedCards.elementsEqual(cardToSelect) && game.selectedCardsMatched == true)
    }
    
    func testSelectCardWhenTwoCardsAreSelectedAndDontMatch() {
        var cardToSelect: [Card]
        game.createNonShuffledDeckForTest()
        game.setCardsOnBoard(newCardsOnBoard: [])
        game.dealTwelveCardsForTest()
        
        cardToSelect = [
            game.cardsOnBoard[0],
            game.cardsOnBoard[11],
            game.cardsOnBoard[2]
        ]
        game.selectCard(at: 0)
        game.selectCard(at: 11)
        game.selectCard(at: 2)
        XCTAssertTrue(game.selectedCards.elementsEqual(cardToSelect) && game.selectedCardsMatched == false)
    }
    func testSelectCardWhenThreeCardsAreMatchedAlready() {
        let cardsToReplace: Array<Card>
        let cardToChoose: Card
        game.createNonShuffledDeckForTest()
        game.setCardsOnBoard(newCardsOnBoard: [])
        game.dealTwelveCardsForTest()
        
        cardsToReplace = [
            game.cardsOnBoard[0],
            game.cardsOnBoard[1],
            game.cardsOnBoard[2]
        ]
        cardToChoose = game.cardsOnBoard[3]
        game.selectCard(at: 0)
        game.selectCard(at: 1)
        game.selectCard(at: 2)
        game.selectCard(at: 3)
        XCTAssertTrue(game.selectedCards.contains(
            cardToChoose) &&
            game.selectedCards.count == 1 &&
            game.cardsOnBoard[0] != cardsToReplace[0] &&
            game.cardsOnBoard[1] != cardsToReplace[1] &&
            game.cardsOnBoard[2] != cardsToReplace[2]
        )
        
    }
    func testSelectCardWhenThreeCardsAreNotMacthedAlready() {
        let cardsToReplace: Array<Card>
        let cardToChoose: Card
        game.createNonShuffledDeckForTest()
        game.setCardsOnBoard(newCardsOnBoard: [])
        game.dealTwelveCardsForTest()
        
        cardsToReplace = [
            game.cardsOnBoard[0],
            game.cardsOnBoard[11],
            game.cardsOnBoard[2]
        ]
        cardToChoose = game.cardsOnBoard[3]
        game.selectCard(at: 0)
        game.selectCard(at: 11)
        game.selectCard(at: 2)
        game.selectCard(at: 3)
        XCTAssertTrue(
            game.selectedCards.contains(cardToChoose) &&
            game.selectedCards.count == 1 &&
            game.cardsOnBoard[0] == cardsToReplace[0] &&
            game.cardsOnBoard[11] == cardsToReplace[1] &&
            game.cardsOnBoard[2] == cardsToReplace[2]
        )
        
    }
    
    func testSelectCardWhenThisCardHaveBeenAlreadySelected() {
        let cardToChoose: Card
        game.createNonShuffledDeckForTest()
        game.setCardsOnBoard(newCardsOnBoard: [])
        game.dealTwelveCardsForTest()
        
        cardToChoose = game.cardsOnBoard[0]
        game.selectCard(at: 0)
        game.selectCard(at: 1)
        game.selectCard(at: 1)
        XCTAssertTrue(
            game.selectedCards.contains(cardToChoose) &&
            game.selectedCards.count == 1
        )
        game.selectCard(at: 1)
        game.selectCard(at: 2)
        game.selectCard(at: 2)
        
        XCTAssertTrue(game.selectedCards.count == 0)
        
    }
    
    
    
}
