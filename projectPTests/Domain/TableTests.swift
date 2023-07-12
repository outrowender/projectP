//
//  PlayerTests.swift
//  projectPTests
//
//  Created by Wender on 08/07/23.
//

import XCTest
@testable import projectP

final class TableTests: XCTestCase {
    
    var poker: Table!
    
    override func setUp() {
        super.setUp()
        
        let p1 = Player(id: "0", credits: 100)
        let p2 = Player(id: "1", credits: 100)
        let p3 = Player(id: "2", credits: 100)
        
        poker = Table(players: [p1, p2, p3])
        
        XCTAssertEqual(poker.round, 0)
        XCTAssertEqual(poker.players.count, 3)
    }

    func testEachPlayerShouldGet2Cards() {

        poker.startGame()

        XCTAssertEqual(poker.round, 1)
        
        XCTAssertEqual(poker.players[0].hands.count, 2)
        XCTAssertEqual(poker.players[1].hands.count, 2)
        XCTAssertEqual(poker.players[2].hands.count, 2)
        
        XCTAssertEqual(poker.deck.count, Deck.full.count - 6)
        XCTAssertEqual(poker.dealer.count, 0)
        XCTAssertEqual(poker.playerIndex, 0)
    }
    
    func testEachPlayerTurnShouldChangePlayerIndex() {

        poker.startGame()
        let player = poker.takeTurn()

        XCTAssertEqual(poker.round, 1)
        XCTAssertEqual(poker.playerIndex, 1)
        XCTAssertEqual(player.id, "1")
    }
    
    func testEachPlayerTurnShouldChangePlayerIndex2() {

        poker.startGame()
        
        _ = poker.takeTurn()
        let player = poker.takeTurn()

        XCTAssertEqual(poker.round, 1)
        XCTAssertEqual(poker.playerIndex, 2)
        XCTAssertEqual(player.id, "2")
    }
    
    func testEachPlayerTurnShouldChangeSkipGameCycle() {

        poker.startGame()
        
        _ = poker.takeTurn()
        _ = poker.takeTurn()
        let player = poker.takeTurn()

        XCTAssertEqual(poker.round, 2)
        XCTAssertEqual(poker.playerIndex, 0)
        XCTAssertEqual(player.id, "0")
    }
    
    func testFirstRoundShouldContaisValidCardsOnTable() {
        
        poker.startGame()
        poker.cycle()
        
        XCTAssertEqual(poker.round, 2)
        
        XCTAssertEqual(poker.players[0].hands.count, 2)
        XCTAssertEqual(poker.players[1].hands.count, 2)
        XCTAssertEqual(poker.players[2].hands.count, 2)
        
        XCTAssertEqual(poker.deck.count, Deck.full.count - 6 - 3)
        XCTAssertEqual(poker.dealer.count, 3)
    }
    
    func testSecondRoundShouldContaisValidCardsOnTable() {
        
        poker.startGame()
        poker.cycle()
        poker.cycle()
        
        XCTAssertEqual(poker.round, 3)
        
        XCTAssertEqual(poker.deck.count, Deck.full.count - 6 - 3 - 1)
        XCTAssertEqual(poker.dealer.count, 4)
    }
    
    func testThirdRoundShouldContaisValidCardsOnTable() {
        
        poker.startGame()
        poker.cycle()
        poker.cycle()
        poker.cycle()
        
        XCTAssertEqual(poker.round, 4)
        
        XCTAssertEqual(poker.deck.count, Deck.full.count - 6 - 3 - 1 - 1)
        XCTAssertEqual(poker.dealer.count, 5)
    }
    
    func testCycleShouldCountCyclesCorrectly() {
        
        poker.startGame()
        poker.cycle()
        poker.cycle()
        poker.cycle()
        
        poker.cycle()
        poker.cycle()
        poker.cycle()
        
        XCTAssertEqual(poker.round, 7)
        
        XCTAssertEqual(poker.deck.count, Deck.full.count - 6 - 3 - 1 - 1)
        XCTAssertEqual(poker.dealer.count, 5)
    }
    
    func testWinnerShouldHaveBestCards() {
        
        poker.startGame()
        poker.cycle()
        poker.cycle()
        poker.cycle()
        
        let winner = poker.winner()
        let players = poker.players.map { $0.hands + poker.dealer }
        
        XCTAssertTrue(Card.compare(players[0], <=, winner.0.hands + poker.deck))
    }

}
