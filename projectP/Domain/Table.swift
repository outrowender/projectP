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
    private(set) var playerIndex = 0
    
    private(set) var pot = 0
    private(set) var bigPot = 0
    
    init(players: [Player]) {
        self.players = players
    }
    
    func play(_ player: Int, decision: Player.Decision) {
        if player != playerIndex {
            assert(false)
        } // TODO: throw something maybe?
        
        players[playerIndex].lastDecision = decision
        
        switch decision {

        case .fold: break
        case .call:
            call(player: playerIndex)
        case .bet(amount: let amount):
            bet(player: playerIndex, value: amount)
        case .allIn:
            allIn(player: playerIndex)
        }
        
        let remaining = players.filter { ($0.bet < bigPot && $0.lastDecision != .fold) || $0.lastDecision == nil }
                
        if remaining.count == 0 {
            cycle()
            return
        }
        
        playerIndex = (playerIndex + 1) % players.count

    }
    
    // MARK: - Player actions
    private func call(player p: Int) {
        let maxPot = players.max { $0.bet < $1.bet }?.bet ?? 0
        players[p].bet(maxPot - players[p].bet)
        
        self.refreshTableBet()
    }
    
    private func bet(player p: Int, value: Int) {
        players[p].bet(value)
        
        self.refreshTableBet()
    }
    
    private func allIn(player p: Int) {
        let all = players[p].credits
        bet(player: p, value: all)
    }

    func startGame() {
        feedPlayersHands()
        round = 1
    }
    
    func cycle() {
        if round == 1 {
            feedTableCards(with: 3)
        }
        
        if round > 1 && round < 4 {
            feedTableCards(with: 1)
        }
        
        round += 1
        playerIndex = 0
        
        for p in 0..<players.count {
            players[p].lastDecision = players[p].lastDecision == .fold ? .fold : nil
        }
    }
    
    func winner() -> (Player, Deck.Hand) {
        let all = players.map { Player(id: $0.id, hands: $0.hands + cards, credits: 0) }
        
        let best = all.max { Card.compare($0.hands, >, $1.hands) }!
        let p = players.first { $0.id == best.id }!
        
        let deck = Deck(cards, ours: p.hands)
        
        return (p, deck.hand)
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
            for _ in 0...1 {
                let card = randomCard()
                players[p].hands.append(card)
            }
        }
    }
}
