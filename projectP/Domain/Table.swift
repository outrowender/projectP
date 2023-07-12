//
//  Table.swift
//  projectP
//
//  Created by Wender on 08/07/23.
//

import Foundation

class Table {
    private(set) var dealer: [Card] = []
    private(set) var players: [Player]
    private(set) var deck = Deck.full
    
    private(set) var round = 0
    
    init(players: [Player]) {
        self.players = players
    }
    
    func randomCard() -> Card {
        let cardIndex = Int.random(in: 0..<deck.count)
        let copy = deck[cardIndex]
        deck.remove(at: cardIndex)
        return copy
    }
    
    func feedDealerHands(with cards: Int) {
        for _ in 1...cards {
            let card = randomCard()
            dealer.append(card)
        }
    }
    
    func startGame() {
        feedPlayersHands()
        round = 1
    }
    
    func cycle() {
        if round == 1 {
            feedDealerHands(with: 3)
        }
        
        if round > 1 && round < 4 {
            feedDealerHands(with: 1)
        }
        
        round += 1
    }
    
    func winner() -> (Player, Deck.Hand) {
        let all = players.map { Player(id: $0.id, hands: $0.hands + dealer, credits: 0) }
        
        let best = all.max { Card.compare($0.hands, >, $1.hands) }!
        let p = players.first { $0.id == best.id }!
        
        let deck = Deck(dealer, ours: p.hands)
        
        return (p, deck.hand)
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

struct Player {
    let id: String
    var hands: [Card] = []
    var credits: Int
}
