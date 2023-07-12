//
//  AIPlayer.swift
//  projectP
//
//  Created by Wender on 12/07/23.
//

import Foundation

class AIPlayer {
    let player: Player
    
    init(_ player: Player) {
        self.player = player
    }
    
    func decide(table: [Card], pot: Int, opponents: Int) -> Decision {
        let deck = Deck(table, ours: player.hands)
        
        if deck.strength > 0.99 {
            return .bet(amount: player.credits)
        }
        
        if deck.strength > 0.90 {
            return .bet(amount: player.credits/3)
        }
        
        if deck.strength > 0.20 {
            return .call
        }
        
        return .fold
    }
}

extension AIPlayer {
    enum Decision: Equatable {
        case fold
        case call
        case bet(amount: Int)
    }
}
