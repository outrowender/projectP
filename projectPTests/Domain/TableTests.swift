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
        XCTAssertEqual(poker.cards.count, 0)
        XCTAssertEqual(poker.playerIndex, 0)
    }
    
    func testPlayShouldGoToNextPlayablePlayer() {
        poker.startGame()
        
        poker.play(0, decision: .call)
        
        XCTAssertEqual(poker.round, 1)
        XCTAssertEqual(poker.playerIndex, 1)
    }
    
    func testPlayAgainShouldGoToNextPlayablePlayer() {
        poker.startGame()
        
        poker.play(0, decision: .call)
        poker.play(1, decision: .call)
        
        XCTAssertEqual(poker.round, 1)
        XCTAssertEqual(poker.playerIndex, 2)
    }
    
    func testPlayAgainAndCallShouldGoToNextPlayablePlayerAndRound() {
        poker.startGame()
        
        poker.play(0, decision: .call)
        poker.play(1, decision: .call)
        poker.play(2, decision: .call)
        
        XCTAssertEqual(poker.round, 2)
        XCTAssertEqual(poker.playerIndex, 0)
    }
    
    func testPlayAgainAndFoldShouldGoToNextPlayablePlayerAndRound() {
        poker.startGame()
        
        poker.play(0, decision: .call)
        poker.play(1, decision: .call)
        poker.play(2, decision: .fold)
        
        poker.play(0, decision: .call)
        
        XCTAssertEqual(poker.round, 2)
        XCTAssertEqual(poker.playerIndex, 1)
    }
    
    func testPlayAndSomeonBetBeforeShouldNotGoToNextRound() {
        poker.startGame()
        
        poker.play(0, decision: .call)
        poker.play(1, decision: .bet(amount: 10))
        poker.play(2, decision: .call)
        poker.play(0, decision: .call)
        
        XCTAssertEqual(poker.round, 2)
        XCTAssertEqual(poker.playerIndex, 0)
    }
    
    func testPlayAndSomeonBetBeforeShouldNotGoToNextRound2() {
        poker.startGame()
        
        poker.play(0, decision: .call)
        poker.play(1, decision: .bet(amount: 10))
        poker.play(2, decision: .call)
        poker.play(0, decision: .call)
        
        XCTAssertEqual(poker.round, 2)
        XCTAssertEqual(poker.playerIndex, 0)
    }
    
    func testPlayAndSomeonBetBeforeShouldNotGoToNextRound3() {
        poker.startGame()
        
        poker.play(0, decision: .call)
        poker.play(1, decision: .bet(amount: 10))
        poker.play(2, decision: .call)
        poker.play(0, decision: .call)
        XCTAssertEqual(poker.round, 2)
        XCTAssertEqual(poker.pot, 30)
        XCTAssertEqual(poker.bigPot, 10)
        XCTAssertEqual(poker.cards.count, 3)

        poker.play(0, decision: .call)
        poker.play(1, decision: .call)
        poker.play(2, decision: .bet(amount: 20))
        poker.play(0, decision: .call)
        poker.play(1, decision: .call)
        XCTAssertEqual(poker.round, 3)
        XCTAssertEqual(poker.pot, 90)
        XCTAssertEqual(poker.bigPot, 30)
        XCTAssertEqual(poker.cards.count, 4)
        
        poker.play(0, decision: .call)
        poker.play(1, decision: .call)
        poker.play(2, decision: .bet(amount: 20))
        poker.play(0, decision: .call)
        poker.play(1, decision: .bet(amount: 20+10))
        poker.play(2, decision: .call)
        poker.play(0, decision: .call)
        XCTAssertEqual(poker.round, 4)
        XCTAssertEqual(poker.pot, 180)
        XCTAssertEqual(poker.bigPot, 60)
        XCTAssertEqual(poker.cards.count, 5)
    }
    
    
    func testPlayShouldIgnoreFolds() {
        poker.startGame()

        poker.play(0, decision: .call) // 2
        poker.play(1, decision: .call) // 1
        poker.play(2, decision: .call) // 0
        XCTAssertEqual(poker.round, 2)

        poker.play(0, decision: .call) // 2
        poker.play(1, decision: .bet(amount: 10)) // 2
        poker.play(2, decision: .fold) // 1
        poker.play(0, decision: .call) // 0
        XCTAssertEqual(poker.round, 3)

        poker.play(0, decision: .call) // 1
        poker.play(1, decision: .bet(amount: 10)) // 1
        poker.play(0, decision: .call) // 0
        XCTAssertEqual(poker.round, 4)


        XCTAssertEqual(poker.pot, 40)
        XCTAssertEqual(poker.bigPot, 20)
        XCTAssertEqual(poker.cards.count, 5)

    }
    
    func testPlayShouldIgnoreFolds2() {
        poker.startGame()

        poker.play(0, decision: .call) // 2
        poker.play(1, decision: .call) // 1
        poker.play(2, decision: .call) // 0
        XCTAssertEqual(poker.round, 2)

        poker.play(0, decision: .fold) // 2
        poker.play(1, decision: .bet(amount: 10)) // 1
        poker.play(2, decision: .call) // 0
        XCTAssertEqual(poker.round, 3)

        poker.play(1, decision: .bet(amount: 10)) // 1
        poker.play(2, decision: .call) // 0
        XCTAssertEqual(poker.round, 4)

        XCTAssertEqual(poker.pot, 40)
        XCTAssertEqual(poker.bigPot, 20)
        XCTAssertEqual(poker.cards.count, 5)

    }
    
    func testPlayShouldIgnoreFolds3() {
        poker.startGame()

        poker.play(0, decision: .call) // 2
        poker.play(1, decision: .call) // 1
        poker.play(2, decision: .fold) // 0
        XCTAssertEqual(poker.round, 2)

        poker.play(0, decision: .call) // 1
        poker.play(1, decision: .bet(amount: 10)) // 1
        poker.play(0, decision: .call) // 0
        XCTAssertEqual(poker.round, 3)

        poker.play(0, decision: .bet(amount: 10)) // 1
        poker.play(1, decision: .call) // 0
        XCTAssertEqual(poker.round, 4)

        XCTAssertEqual(poker.pot, 40)
        XCTAssertEqual(poker.bigPot, 20)
        XCTAssertEqual(poker.cards.count, 5)

    }

}
