//
//  Player.swift
//  projectP
//
//  Created by Wender on 14/07/23.
//

import Foundation

struct Player: Equatable {
    let id: String
    let name: String
    var hands: [Card] = []
    var lastDecision: Decision?
    
    private(set) var credits: Int
    private(set) var bet: Int = 0
    
    mutating func bet(_ value: Int) {
        bet += value
        credits -= value
    }
    
    mutating func allIn() -> Int {
        let cr = credits
        bet(credits)
        return cr
    }
    
    mutating func pay(_ value: Int) {
        bet = 0
        credits += value
    }
    
    mutating func charge() -> Int {
        let currentBet = bet
        bet = 0
        return currentBet
    }
    
    mutating func reset() {
        bet = 0
        lastDecision = nil
    }

    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id
    }
}

extension Player {
    enum Decision: Equatable, CustomStringConvertible {
        case fold
        case check
        case bet(amount: Int)
        case allIn
        
        var description: String {
            switch self {
                
            case .fold:
                return "Folded"
            case .check:
                return "Check"
            case .bet(amount: let amount):
                return "Bet \(amount) CR"
            case .allIn:
                return "All in"
            }
        }
    }
}
