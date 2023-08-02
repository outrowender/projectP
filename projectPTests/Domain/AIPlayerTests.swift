//
//  AIPlayerTests.swift
//  projectPTests
//
//  Created by Wender on 12/07/23.
//

import XCTest
@testable import projectP

final class AIPlayerTests: XCTestCase {
    
    func testAIplayerShouldAllWithStrongHand() {
        let player = Player(id: "1", name: "1", hands: Card.array("A♠️ K♠️"), credits: 50)
        let table = Card.array("4♥️ 2♣️ Q♠️ J♠️ 10♠️")
        
        let decision = AIPlayer(player).decide(table: table, pot: 300, opponents: 3)
            
        XCTAssertEqual(decision, .bet(amount: 50))
    }

}
