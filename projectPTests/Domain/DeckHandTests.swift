//
//  DeckHandTests.swift
//  projectPTests
//
//  Created by Wender on 06/07/23.
//

import XCTest
@testable import projectP

final class DeckHandTests: XCTestCase {

    func testComputeFullHandShouldReturnAFlush() {
        // Arrange/Act
        let deck = Deck("5♠️ J♠️ 8♠️ 2♠️ J♦️ 9♠️ A♥️")
        // Assert
        let expected = Card.array("J♠️ 9♠️ 8♠️ 5♠️ 2♠️")
        XCTAssertEqual(deck.hand, .flush(expected))
    }

}
