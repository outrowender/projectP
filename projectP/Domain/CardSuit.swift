//
//  Suit.swift
//  projectP
//
//  Created by Wender on 14/07/23.
//

import Foundation

extension Card {
    // MARK: - Suit logic
    
    enum Suit: Int, CaseIterable, CustomStringConvertible {
        case spade = 65536, heart = 32768, club = 16384, diamond = 8192
        
        init?(_ value: String) {
            let suits: [String: Suit] = ["♣️": .club, "♦️": .diamond, "♠️": .spade, "♥️": .heart]
            self.init(rawValue: suits[value]!.rawValue)
        }
        
        var color: String {
            let values: [Suit: String] = [.spade: "B", .heart: "R", .club: "B", .diamond: "R" ]
            return values[self] ?? "?"
        }
        
        var description: String {
            let values: [Suit: String] = [.spade: "♠️", .heart: "♥️", .club: "♣️", .diamond: "♦️" ]
            return values[self] ?? "?"
        }
        
    }
}

extension Card.Suit: Comparable {
    static func < (lhs: Card.Suit, rhs: Card.Suit) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    static func == (lhs: Card.Suit, rhs: Card.Suit) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}
