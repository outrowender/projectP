//
//  DeckHandComparisonTests.swift
//  projectPTests
//
//  Created by Wender on 07/07/23.
//

import XCTest
@testable import projectP

final class DeckHandComparisonTests: XCTestCase {

    func testHandOfRoyalFlushOverFlushShouldBeWin() {
        // Arrange
        let deck1 = Deck("A♦️ K♦️ Q♦️ J♦️ A♠️", ours: "10♦️ 8♥️")
        let deck2 = Deck("A♦️ K♦️ Q♦️ J♦️ A♠️", ours: "7♦️ 4♥️")
        let deck3 = Deck("A♦️ K♦️ Q♦️ J♦️ A♠️", ours: "3♦️ 3♥️")
        // Act
        let expected = Deck.bestHands([deck1.hand, deck2.hand, deck3.hand])
        // Assert
        XCTAssertEqual(expected, .royalFlush(Card.array("A♦️ K♦️ Q♦️ J♦️ 10♦️")))
        XCTAssertGreaterThan(deck1.strength, deck2.strength)
    }
    
    func testHandOf3KindShouldWin() {
        // Arrange
        let deck1 = Deck("10♠️ 3♦️ 2♣️ J♦️ A♥️", ours: "10♦️ 10♥️")
        let deck2 = Deck("10♠️ 3♦️ 2♣️ J♦️ A♥️", ours: "10♣️ 8♥️")
        let deck3 = Deck("10♠️ 3♦️ 2♣️ J♦️ A♥️", ours: "6♦️ 7♥️")
        //Act
        let expected = Deck.bestHands([deck1.hand, deck2.hand, deck3.hand])
        // Assert
        XCTAssertEqual(expected, .threeOfAKind(Card.array("10♠️ 10♥️ 10♦️")))
        XCTAssertGreaterThan(deck1.strength, deck2.strength)
    }
    
    func testHandOfGreaterPairShouldWin() {
        // Arrange
        let deck1 = Deck("10♠️ 3♦️ 2♣️ K♦️ A♥️", ours: "9♦️ A♦️")
        let deck2 = Deck("10♠️ 3♦️ 2♣️ K♦️ A♥️", ours: "8♦️ K♦️")
        let deck3 = Deck("10♠️ 3♦️ 2♣️ K♦️ A♥️", ours: "7♦️ Q♦️")
        //Act
        let expected = Deck.bestHands([deck1.hand, deck2.hand, deck3.hand])
        // Assert
        XCTAssertEqual(expected, .pair(Card.array("A♥️ A♦️")))
        XCTAssertGreaterThan(deck1.strength, deck2.strength)
    }

}
