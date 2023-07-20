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
    
    func testPlayAndSomeonBetEveryoneShouldBet() {
        poker.startGame()
        
        poker.play(0, decision: .call)
        poker.play(1, decision: .bet(amount: 10))
        poker.play(2, decision: .call)
        poker.play(0, decision: .call)
        XCTAssertEqual(poker.round, 2)
        XCTAssertEqual(poker.pot, 60)
        XCTAssertEqual(poker.bigPot, 20)
        XCTAssertEqual(poker.cards.count, 3)

        poker.play(0, decision: .call)
        poker.play(1, decision: .call)
        poker.play(2, decision: .bet(amount: 20))
        poker.play(0, decision: .call)
        poker.play(1, decision: .call)
        XCTAssertEqual(poker.round, 3)
        XCTAssertEqual(poker.pot, 120)
        XCTAssertEqual(poker.bigPot, 40)
        XCTAssertEqual(poker.cards.count, 4)
        
        poker.play(0, decision: .call)
        poker.play(1, decision: .call)
        poker.play(2, decision: .bet(amount: 20))
        poker.play(0, decision: .call)
        poker.play(1, decision: .bet(amount: 20+10))
        poker.play(2, decision: .call)
        poker.play(0, decision: .call)
        XCTAssertEqual(poker.round, 4)
        XCTAssertEqual(poker.pot, 270)
        XCTAssertEqual(poker.bigPot, 90)
        XCTAssertEqual(poker.cards.count, 5)
        
        poker.play(0, decision: .call)
        poker.play(1, decision: .call)
        poker.play(2, decision: .call)
        XCTAssertTrue(poker.winner != nil)
        XCTAssertEqual(poker.players[poker.winner!].credits, 280)
        XCTAssertEqual(poker.pot, 0)
    }
    
    
    func testPlaySomeoneFoldsGameShouldContinue() {
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

        XCTAssertEqual(poker.pot, 70)
        XCTAssertEqual(poker.bigPot, 30)
        XCTAssertEqual(poker.cards.count, 5)

    }
    
    func testPlaySomeoneFoldsGameShouldContinue2() {
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

        XCTAssertEqual(poker.pot, 70)
        XCTAssertEqual(poker.bigPot, 30)
        XCTAssertEqual(poker.cards.count, 5)

    }
    
    func testPlaySomeoneFoldsGameShouldContinue3() {
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

        XCTAssertEqual(poker.pot, 60)
        XCTAssertEqual(poker.bigPot, 30)
        XCTAssertEqual(poker.cards.count, 5)
    }
    
    func testPlayAndGameEndsShouldCleanEverything() {
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

        XCTAssertEqual(poker.pot, 60)
        XCTAssertEqual(poker.bigPot, 30)
        XCTAssertEqual(poker.cards.count, 5)

        poker.startGame()
        XCTAssertEqual(poker.round, 1)
        
        XCTAssertEqual(poker.players[0].hands.count, 2)
        XCTAssertEqual(poker.players[1].hands.count, 2)
        XCTAssertEqual(poker.players[2].hands.count, 2)
        
        XCTAssertEqual(poker.pot, 0)
        XCTAssertEqual(poker.bigPot, 10)
        XCTAssertEqual(poker.deck.count, Deck.full.count - 6)
        XCTAssertEqual(poker.cards.count, 0)
        XCTAssertEqual(poker.playerIndex, 0)
        
        XCTAssertEqual(poker.players[0].bet, 0)
        XCTAssertEqual(poker.players[1].bet, 0)
        XCTAssertEqual(poker.players[2].bet, 0)
    }
    
    func testPlayEveryoneFoldsShouldHaveAWinner() {
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
        poker.play(1, decision: .fold) // 0
        XCTAssertEqual(poker.round, 3)

        XCTAssertEqual(poker.bigPot, 30)
        XCTAssertEqual(poker.winner, 0)
        XCTAssertEqual(poker.players[0].credits, 120)
        XCTAssertEqual(poker.players[1].credits, 80)
        XCTAssertEqual(poker.players[2].credits, 100)

    }
    
    func testPlayAndGameEndsShouldHaveAWinner() {
        poker.startGame()

        poker.play(0, decision: .call) // 2
        poker.play(1, decision: .call) // 1
        poker.play(2, decision: .fold) // 0
        XCTAssertEqual(poker.round, 2)
        XCTAssertEqual(poker.pot, 20)
        XCTAssertEqual(poker.players[0].bet, 10)
        XCTAssertEqual(poker.players[1].bet, 10)
        XCTAssertEqual(poker.players[2].bet, 0)
        
        poker.play(0, decision: .call) // 1
        poker.play(1, decision: .bet(amount: 10)) // 1
        poker.play(0, decision: .call) // 0
        XCTAssertEqual(poker.round, 3)

        poker.play(0, decision: .bet(amount: 10)) // 1
        poker.play(1, decision: .call) // 0
        XCTAssertEqual(poker.round, 4)
        XCTAssertEqual(poker.pot, 60)
        
        poker.play(0, decision: .call) // 1
        poker.play(1, decision: .call) // 0
        
        XCTAssertTrue(poker.winner != nil)
        XCTAssertEqual(poker.players[poker.winner!].credits, 130)
        XCTAssertEqual(poker.pot, 0)
        XCTAssertEqual(poker.bigPot, 30)
    }

}
