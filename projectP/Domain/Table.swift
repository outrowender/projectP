//
//  Table.swift
//  projectP
//
//  Created by Wender on 08/07/23.
//

import Foundation

class Table {
    private(set) var cards: [Card] = []
    private(set) var deck = Deck.full
    private(set) var players: [Player]
    
    private(set) var round = 0
    let playerIndex = Observable(0)
    
    private(set) var pot = 0
    private(set) var bigPot = 0
    
    let winner: Observable<Int?> = Observable(nil)
    
    init(players: [Player]) {
        self.players = players
    }
    
    func play(_ player: Int, decision: Player.Decision) {
        assert(player == playerIndex.value, "Illegal action!")
        
        players[playerIndex.value].lastDecision = decision
        decide(decision)
        
        let remaining = players.filter { ($0.bet < bigPot && $0.lastDecision != .fold && $0.lastDecision != .allIn) || $0.lastDecision == nil }
                
        if remaining.count == 0 {
            cycle()
            return
        }
        
        repeat {
            playerIndex.value = (playerIndex.value + 1) % players.count
        } while players[playerIndex.value].lastDecision == .fold || players[playerIndex.value].lastDecision == .allIn
    }
    
    func startGame() {
        cards = []
        deck = Deck.full
        playerIndex.value = 0
        round = 1
        pot = 0
        bigPot = 10
        winner.value = nil
        
        for p in 0..<players.count {
            players[p].reset()
        }
        
        feedPlayersHands()
    }
    
    func cycle() {
        if round == 1 {
            feedTableCards(with: 3)
        }
        
        if round > 1 && round < 4 {
            feedTableCards(with: 1)
        }
        
        if round == 4 {
            let winner = checkWinner()
            let p = players.firstIndex(of: winner.0)!
            finishGame(winner: p)
            return
        }
        
        round += 1
        playerIndex.value = 0
        
        for p in 0..<players.count {
            players[p].lastDecision = players[p].lastDecision == .fold || players[p].lastDecision == .allIn ? players[p].lastDecision : nil
        }
        
        let remaining = players.filter { $0.lastDecision != .fold && $0.lastDecision != .allIn }

        if remaining.count == 0 {
            round = 4
            feedTableCards(with: 5)
            let winner = checkWinner()
            let p = players.firstIndex(of: winner.0)!
            finishGame(winner: p)
            return
        }

        while players[playerIndex.value].lastDecision == .fold || players[playerIndex.value].lastDecision == .allIn {
            playerIndex.value = (playerIndex.value + 1) % players.count
        }
    }
    
    private func refreshTableBet() {
        var p = 0
        var max = 0
        
        for i in players {
            if i.bet > max { max = i.bet }
            p += i.bet
        }
        
        pot = p
        bigPot = max
    }
    
    private func randomCard() -> Card {
        let cardIndex = Int.random(in: 0..<deck.count)
        let copy = deck[cardIndex]
        deck.remove(at: cardIndex)
        return copy
    }
    
    private func feedTableCards(with n: Int) {
        for _ in 1...n {
            let card = randomCard()
            self.cards.append(card)
        }
    }
    
    private func feedPlayersHands() {
        for p in 0..<players.count {
            players[p].hands = []
            for _ in 0...1 {
                let card = randomCard()
                players[p].hands.append(card)
            }
        }
    }
}

// MARK: - Player decisions
extension Table {
    private func decide(_ decision: Player.Decision) {
        switch decision {
        case .fold:
            fold(player: playerIndex.value)
        case .check:
            check(player: playerIndex.value)
        case .bet(amount: let amount):
            bet(player: playerIndex.value, value: amount)
        case .allIn:
            allIn(player: playerIndex.value)
        }
    }
    
    private func fold(player p: Int) {
        let remaining = players.filter { $0.lastDecision != .fold }
        
        if remaining.count == 1 {
            let p = players.firstIndex(of: remaining.first!)!
            finishGame(winner: p)
            return
        }

        self.refreshTableBet()
    }
    
    private func check(player p: Int) {
        var bet = bigPot - players[p].bet
        if players[p].credits < bet {
            bet = players[p].credits
            players[p].lastDecision = .allIn
        }
        
        players[p].bet(bet)
        
        if players[p].credits == 0 { //  TODO: optimize
            players[p].lastDecision = .allIn
        }
        
        self.refreshTableBet()
    }
    
    private func bet(player p: Int, value: Int) {
        var bet = (bigPot - players[p].bet) + value
        if players[p].credits < bet {
            bet = players[p].credits
            players[p].lastDecision = .allIn
        }
        players[p].bet(bet)
        self.refreshTableBet()
    }
    
    private func allIn(player p: Int) {
        let all = players[p].credits
        bet(player: p, value: all)
    }
    
    private func finishGame(winner p: Int) {
        winner.value = p
        players[p].pay(pot)
        pot = 0
    }
    
    private func checkWinner() -> (Player, Deck.Hand) {
        let remaining = players.filter { $0.lastDecision != .fold }
        let all = remaining.map { Player(id: $0.id, name: $0.name, hands: $0.hands + cards, credits: $0.credits) } // TODO: rework remap
        
        let best = all.max { Card.compare($0.hands, >, $1.hands) }!
        let p = players.first { $0.id == best.id }!
        
        let deck = Deck(cards, ours: p.hands)
        
        return (p, deck.hand)
    }
}
