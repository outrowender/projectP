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
    
    func testBiggerPairShouldBeBiggest() {
        let hand1 = Card.array("Q♠️ Q♦️")
        let hand2 = Card.array("J♠️ J♦️")
        // Assert
        XCTAssertTrue(Card.compare(hand1, >, hand2))
    }
    
}
