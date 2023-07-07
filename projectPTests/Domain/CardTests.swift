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
    
}
