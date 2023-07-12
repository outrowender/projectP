//
//  CardTests.swift
//  projectPTests
//
//  Created by Wender on 04/07/23.
//

import XCTest
@testable import projectP

final class CardTests: XCTestCase {

    func testCardJackShouldBeBiggerThenTen() {
        // Assert
        XCTAssertGreaterThan(Card("J♥️"), Card("10♥️"))
    }
    
    func testGreaterPairShouldWin() {
        let hand1 = Card.array("Q♠️ Q♦️")
        let hand2 = Card.array("J♠️ J♦️")
        // Assert
        XCTAssertTrue(Card.compare(hand1, >, hand2))
    }
    
    func testEqualPairsGreaterSuitShouldWin() {
        let hand1 = Card.array("Q♠️ Q♦️")
        let hand2 = Card.array("Q♣️ Q♥️")
        // Assert
        XCTAssertTrue(Card.compare(hand1, >, hand2))
    }
    
    func testPairsGreaterPairShouldWin() {
        let hand1 = Card.array("A♥️ 3♥️")
        let hand2 = Card.array("Q♠️ J♥️")
        // Assert
        XCTAssertTrue(Card.compare(hand1, >, hand2))
        XCTAssertEqual(Deck([], ours: hand1).strength, 0.95)
    }
    
    func testTwoPairGreaterPairsShouldWin() {
        let hand1 = Card.array("J♣️ J♥️ 6♥️ 6♣️")
        let hand2 = Card.array("J♠️ J♦️ 5♣️ 5♥️")
        // Assert
        XCTAssertTrue(Card.compare(hand1, >, hand2))
    }
    
    func testTwoPairGreaterPairsSuitShouldWin() {
        let hand1 = Card.array("J♥️ J♦️ 6♥️ 6♠️")
        let hand2 = Card.array("J♠️ J♣️ 6♦️ 6♣️")
        // Assert
        XCTAssertTrue(Card.compare(hand1, >, hand2))
    }
    
    func testTwoPairEqualsPairsSuitShouldTie() {
        let hand1 = Card.array("J♣️ J♦️ 6♥️ 6♠️")
        let hand2 = Card.array("J♠️ J♥️ 6♦️ 6♣️")
        // Assert
        XCTAssertTrue(Card.compare(hand1, ==, hand2))
    }
    
    func test3KindGreaterCardsShouldWin() {
        let hand1 = Card.array("J♣️ J♦️ J♥️")
        let hand2 = Card.array("10♠️ 10♥️ 10♦️")
        // Assert
        XCTAssertTrue(Card.compare(hand1, >, hand2))
    }
    
    func testRoyalFlushOverPairShouldWin() {
        let hand1 = Card.array("A♦️ K♦️ Q♦️ J♦️ 7♠️ 10♦️ 8♥️")
        let hand2 = Card.array("A♦️ 2♠️ 4♥️ 6♣️ 8♠️ 10♦️ 2♥️")
        // Assert
        XCTAssertTrue(Card.compare(hand1, >, hand2))
    }
    
    func testRandomHandShouldMatchPercentage() {
        let hand1 = Deck("K♣️ 10♥️ 5♦️", ours: "K♥️ J♣️")
        let hand2 = Deck("K♣️ 10♥️ 5♦️", ours: "6♠️ 5♠️")
        // Assert
        XCTAssertTrue(hand1 > hand2)
//        XCTAssertEqual(hand1.strength, 0.82) // TODO: check percentages
//        XCTAssertEqual(hand2.strength, 0.18)
    }
    
}
