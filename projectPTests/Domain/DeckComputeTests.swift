//
//  PokerTests.swift
//  projectPTests
//
//  Created by Wender on 04/07/23.
//

import XCTest
@testable import projectP

final class DeckComputeTests: XCTestCase {

    // MARK: - Royal Flush tests
    func testComputeFullHandShouldReturnARoyalFlush() {
        // Arrange/Act
        let deck = Deck("A♦️ K♦️ Q♦️ J♦️ 7♠️", ours: "10♦️ 8♥️")
        // Assert
        XCTAssertEqual(deck.hand, .royalFlush(Card.array("A♦️ K♦️ Q♦️ J♦️ 10♦️")))
        XCTAssertEqual(deck.strength, 1.0)
    }
    
    func testComputeHandOf7ShouldReturnARoyalFlush() {
        // Arrange/Act
        let deck = Deck("A♦️ K♦️ Q♦️ J♦️ 9♠️", ours: "10♦️ 8♥️")
        // Assert
        let expected = Card.array("A♦️ K♦️ Q♦️ J♦️ 10♦️")
        XCTAssertEqual(deck.hand, .royalFlush(expected))
        XCTAssertEqual(deck.strength, 1.0)
    }
    
    func testComputeHandOf5ShouldReturnARoyalFlush() {
        // Arrange/Act
        let deck = Deck("A♦️ K♦️ Q♦️", ours: "10♦️ J♦️")
        // Assert
        let expected = Card.array("A♦️ K♦️ Q♦️ J♦️ 10♦️")
        XCTAssertEqual(deck.hand, .royalFlush(expected))
        XCTAssertEqual(deck.strength, 1.0)
    }
    
    // MARK: - Straight flush tests
    func testComputeFullHandShouldReturnAStraightFlush() {
        // Arrange/Act
        let deck = Deck("8♣️ 7♣️ 6♣️ 5♣️ 2♠️", ours: "4♣️ 10♥️")
        // Assert
        let expected = Card.array("8♣️ 7♣️ 6♣️ 5♣️ 4♣️")
        XCTAssertEqual(deck.hand, .straightFlush(expected))
        XCTAssertEqual(deck.strength, 0.98)
    }
    
    func testComputeHandOf7ShouldReturnAStraightFlush() {
        // Arrange/Act
        let deck = Deck("8♣️ 7♣️ 6♣️ 5♣️ 4♣️", ours: "2♣️ 3♣️")
        // Assert
        let expected = Card.array("8♣️ 7♣️ 6♣️ 5♣️ 4♣️")
        XCTAssertEqual(deck.hand, .straightFlush(expected))
        XCTAssertEqual(deck.strength, 0.49)
    }
    
    // MARK: - 4 of a kind tests
    func testComputeFullHandShouldReturnAFourOfAKind() {
        // Arrange/Act
        let deck = Deck("J♣️ J♦️ J♥️ 5♣️ 2♠️", ours: "J♠️ 2♠️")
        // Assert
        let expected = Card.array("J♠️ J♥️ J♣️ J♦️")
        XCTAssertEqual(deck.hand, .fourOfAKind(expected))
        XCTAssertEqual(deck.strength, 1.0)
    }
    
    func testComputeHandOf4ShouldReturnAFourOfAKind() {
        // Arrange/Act
        let deck = Deck("J♣️ J♦️", ours: "J♥️ J♠️")
        // Assert
        let expected = Card.array("J♠️ J♥️ J♣️ J♦️")
        XCTAssertEqual(deck.hand, .fourOfAKind(expected))
        XCTAssertEqual(deck.strength, 1.0)
    }
    
    // MARK: - Full House tests
    func testComputeHandOf7ShouldReturnAFullHouse() {
        // Arrange/Act
        let deck = Deck("10♣️ 10♦️ 9♥️ 10♠️ K♦️", ours: "9♦️ 2♠️")
        // Assert
        let expectedTrio = Card.array("10♠️ 10♣️ 10♦️")
        let expectedDuo = Card.array("9♥️ 9♦️")
        XCTAssertEqual(deck.hand, .fullHouse(expectedTrio + expectedDuo))
        XCTAssertEqual(deck.strength, 0.74)
    }
    
    func testComputeHandOf5ShouldReturnAFullHouse() {
        // Arrange/Act
        let deck = Deck("10♣️ 10♦️ 9♥️", ours: "10♠️ 9♦️")
        // Assert
        let expectedTrio = Card.array("10♠️ 10♣️ 10♦️")
        let expectedDuo = Card.array("9♥️ 9♦️")
        XCTAssertEqual(deck.hand, .fullHouse(expectedTrio + expectedDuo))
        XCTAssertEqual(deck.strength, 1.0)
    }
    
    // MARK: - Flush tests
    func testComputeFullHandShouldReturnAFlush() {
        // Arrange/Act
        let deck = Deck("5♠️ J♠️ 8♠️ 2♠️ J♦️", ours: "9♠️ A♥️")
        // Assert
        let expected = Card.array("J♠️ 9♠️ 8♠️ 5♠️ 2♠️")
        XCTAssertEqual(deck.hand, .flush(expected))
        XCTAssertEqual(deck.strength, 0.8)
    }
    
    func testComputeHandOf7ShouldReturnAFlush() {
        // Arrange/Act
        let deck = Deck("5♠️ J♠️ 8♠️ 2♠️ K♠️", ours: "9♠️ A♠️")
        // Assert
        let expected = Card.array("A♠️ K♠️ J♠️ 9♠️ 8♠️")
        XCTAssertEqual(deck.hand, .flush(expected))
        XCTAssertEqual(deck.strength, 1.0)
    }
    
    func testComputeHandOf5ShouldReturnAFlush() {
        // Arrange/Act
        let deck = Deck("5♠️ J♠️ 8♠️", ours: "2♠️ 9♠️")
        // Assert
        let expected = Card.array("J♠️ 9♠️ 8♠️ 5♠️ 2♠️")
        XCTAssertEqual(deck.hand, .flush(expected))
        XCTAssertEqual(deck.strength, 0.98)
    }
    
    func testComputeFullHandShouldReturnAFlushIfThereIsBiggerCards() {
        // Arrange/Act
        let deck = Deck("5♠️ J♠️ 8♠️ 2♠️ J♦️", ours: "9♠️ A♦️")
        // Assert
        let expected = Card.array("J♠️ 9♠️ 8♠️ 5♠️ 2♠️")
        XCTAssertEqual(deck.hand, .flush(expected))
        XCTAssertEqual(deck.strength, 0.8)
    }
    
    // MARK: - Straight tests
    func testComputeFullHandShouldReturnAStraight() {
        // Arrange/Act
        let deck = Deck("9♣️ A♠️ 8♦️ 2♠️ 6♥️", ours: "5♠️ 7♥️")
        // Assert
        let expected = Card.array("9♣️ 8♦️ 7♥️ 6♥️ 5♠️")
        XCTAssertEqual(deck.hand, .straight(expected))
        XCTAssertEqual(deck.strength, 1.0)
    }
    
    func testComputeFullHandOf7ShouldReturnAStraight() {
        // Arrange/Act
        let deck = Deck("9♣️ 4♠️ 8♦️ 3♠️ 6♥️", ours: "5♠️ 7♥️")
        // Assert
        let expected = Card.array("9♣️ 8♦️ 7♥️ 6♥️ 5♠️")
        XCTAssertEqual(deck.hand, .straight(expected))
        XCTAssertEqual(deck.strength, 1.0)
    }
    
    func testComputeFullHandOf7BigSequenceShouldReturnAStraight() {
        // Arrange/Act
        let deck = Deck("9♣️ J♠️ 8♦️ K♠️ 6♥️", ours: "5♠️ 7♥️")
        // Assert
        let expected = Card.array("9♣️ 8♦️ 7♥️ 6♥️ 5♠️")
        XCTAssertEqual(deck.hand, .straight(expected))
        XCTAssertEqual(deck.strength, 1.0)
    }

    // MARK: - 3 of a kind tests
    func testComputeFullHandShouldReturnAThreeOfAKind() {
        // Arrange/Act
        let deck = Deck("7♣️ A♦️ 2♦️ 3♠️ 4♥️", ours: "7♠️ 7♥️")
        // Assert
        let expected = Card.array("7♠️ 7♥️ 7♣️")
        XCTAssertEqual(deck.hand, .threeOfAKind(expected))
        XCTAssertEqual(deck.strength, 1.0)
    }
    
    func testComputeHandOf3ShouldReturnAThreeOfAKind() {
        // Arrange/Act
        let deck = Deck("7♣️", ours: "7♠️ 7♥️")
        // Assert
        let expected = Card.array("7♠️ 7♥️ 7♣️")
        XCTAssertEqual(deck.hand, .threeOfAKind(expected))
        XCTAssertEqual(deck.strength, 1.0)
    }
    
    // MARK: - Two pairs tests
    func testComputeHandOf7ShouldReturnATwoPairs() {
        // Arrange/Act
        let deck = Deck("4♣️ 3♦️ 4♠️ 3♥️ K♦️", ours: "J♠️ Q♣️")
        // Assert
        let pair1 = Card.array("4♠️ 4♣️")
        let pair2 = Card.array("3♥️ 3♦️")
        XCTAssertEqual(deck.hand, .twoPairs(pair1 + pair2))
        XCTAssertEqual(deck.strength, 0.34)
    }
    
    func testComputeHandOf4ShouldReturnATwoPairs() {
        // Arrange/Act
        let deck = Deck("4♣️ 3♦️", ours: "4♠️ 3♥️")
        // Assert
        let pair1 = Card.array("4♠️ 4♣️")
        let pair2 = Card.array("3♥️ 3♦️")
        XCTAssertEqual(deck.hand, .twoPairs(pair1 + pair2))
        XCTAssertEqual(deck.strength, 1.0)
    }
    
    // MARK: - Pair tests
    func testComputeFullHandOf2ShouldReturnAPair() {
        // Arrange/Act
        let deck = Deck(nil, ours: "A♥️ A♦️")
        // Assert
        let expected = Card.array("A♥️ A♦️")
        XCTAssertEqual(deck.hand, .pair(expected))
        XCTAssertEqual(deck.strength, 1.0)
    }
    
    func testComputeFullHandOf3ShouldReturnAPair() {
        // Arrange/Act
        let deck = Deck("A♥️", ours: "8♦️ A♦️")
        // Assert
        let expected = Card.array("A♥️ A♦️")
        XCTAssertEqual(deck.hand, .pair(expected))
        XCTAssertEqual(deck.strength, 0.92)
    }
    
    func testComputeFullHandShouldReturnAPair() {
        // Arrange/Act
        let deck = Deck("A♥️ 8♦️ 4♣️ 6♠️ 2♠️", ours: "A♦️ 3♥️")
        // Assert
        let expected = Card.array("A♥️ A♦️")
        XCTAssertEqual(deck.hand, .pair(expected))
        XCTAssertEqual(deck.strength, 0.85)
    }
    
    // MARK: - High card tests
    func testComputeFullHandShouldReturnAHighCard() {
        // Arrange/Act
        let deck = Deck("3♥️ J♦️ 8♣️ 4♠️ 2♠️", ours: "6♦️ K♥️")
        // Assert
        let expected = Card("K♥️")
        XCTAssertEqual(deck.hand, .highCard(expected))
        XCTAssertEqual(deck.strength, 0.4)
    }
    
    func testComputeFullHandOf2ShouldReturnAHighCard() {
        // Arrange/Act
        let deck = Deck(nil, ours: "2♥️ 3♦️")
        // Assert
        XCTAssertEqual(deck.hand, .highCard(Card("3♦️")))
        XCTAssertEqual(deck.strength, 0.12)
    }

}
