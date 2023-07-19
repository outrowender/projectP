//
//  PlayerTests.swift
//  projectPTests
//
//  Created by Wender on 18/07/23.
//

import XCTest
@testable import projectP

final class PlayerTests: XCTestCase {
    
    func testInitShouldBeValid() {
        let player = Player(id: "a", credits: 100)
        
        XCTAssertEqual(player.bet, 0)
        XCTAssertEqual(player.credits, 100)
    }
    
    func testBetShouldRemoveMoneyFromCreditAndMoveToBet() {
        var player = Player(id: "a", credits: 100)
        
        player.bet(20)
        
        XCTAssertEqual(player.bet, 20)
        XCTAssertEqual(player.credits, 80)
    }
    
    func testBetShouldRemoveMoneyFromCreditAndMoveToBetTwice() {
        var player = Player(id: "a", credits: 100)
        
        player.bet(20)
        player.bet(30)
        
        XCTAssertEqual(player.bet, 50)
        XCTAssertEqual(player.credits, 50)
    }
    
    func testPayShouldRestoreCredits() {
        var player = Player(id: "a", credits: 100)
        
        player.pay(50)
        
        XCTAssertEqual(player.credits, 150)
    }
    
    func testChargeShouldTakeOnlyBet() {
        var player = Player(id: "a", credits: 100)
        
        player.bet(50)
        let charge = player.charge()
        
        XCTAssertEqual(player.bet, 0)
        XCTAssertEqual(player.credits, 50)
        XCTAssertEqual(charge, 50)
    }
    
    func testAllInShouldTakeAllCredits() {
        var player = Player(id: "a", credits: 100)
        
        let amount = player.allIn()
        
        XCTAssertEqual(player.bet, 100)
        XCTAssertEqual(player.credits, 0)
        XCTAssertEqual(amount, 100)
    }

}
