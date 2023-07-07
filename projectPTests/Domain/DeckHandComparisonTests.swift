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
        // Arrange/Act
        let deck1 = Deck("A♦️ K♦️ Q♦️ J♦️ A♠️", ours: "10♦️ 8♥️")
        let deck2 = Deck("A♦️ K♦️ Q♦️ J♦️ A♠️", ours: "7♦️ 4♥️")
        let deck3 = Deck("A♦️ K♦️ Q♦️ J♦️ A♠️", ours: "3♦️ 3♥️")
        // Assert
        let expected = Deck.bestHands([deck1.hand, deck2.hand, deck3.hand])
        
        XCTAssertEqual(expected, .royalFlush(Card.array("A♦️ K♦️ Q♦️ J♦️ 10♦️")))
    }
    
    func testHandOf3KindShouldWin() {
        // Arrange/Act
        let deck1 = Deck("10♠️ 3♦️ 2♣️ J♦️ A♥️", ours: "10♦️ 10♥️")
        let deck2 = Deck("10♠️ 3♦️ 2♣️ J♦️ A♥️", ours: "10♣️ 8♥️")
        let deck3 = Deck("10♠️ 3♦️ 2♣️ J♦️ A♥️", ours: "6♦️ 7♥️")
        // Assert
        let expected = Deck.bestHands([deck1.hand, deck2.hand, deck3.hand])
        
        XCTAssertEqual(expected, .threeOfAKind(Card.array("10♠️ 10♥️ 10♦️")))
    }
    
    func testHandOfGreaterPairShouldWin() {
        // Arrange/Act
        let deck1 = Deck("10♠️ 3♦️ 2♣️ K♦️ A♥️", ours: "9♦️ A♦️")
        let deck2 = Deck("10♠️ 3♦️ 2♣️ K♦️ A♥️", ours: "8♦️ K♦️")
        let deck3 = Deck("10♠️ 3♦️ 2♣️ K♦️ A♥️", ours: "7♦️ Q♦️")
        // Assert
        let expected = Deck.bestHands([deck1.hand, deck2.hand, deck3.hand])
        
        XCTAssertEqual(expected, .pair(Card.array("A♥️ A♦️")))
    }

}
