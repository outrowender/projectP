//
//  Poker.swift
//  projectP
//
//  Created by Wender on 04/07/23.
//

import Foundation

// MARK: - Card logic
struct Card: CustomStringConvertible, Hashable {
    let rank: Rank
    let suit: Suit
    
    init(_ rank: Rank, _ suit: Suit) {
        self.rank = rank
        self.suit = suit
    }
    
    init(_ value: String) {
        let prefix = value.count == 3 ? value.prefix(2) : value.prefix(1)
        let suffix = value.suffix(1)
        self.rank = Rank(String(prefix))!
        self.suit = Suit(String(suffix))!
    }

    static func array(_ from: String) -> [Card] {
        return from.components(separatedBy: " ").map { Card($0) }
    }
    
    var description: String {
        "\(rank)\(suit)"
    }
}

extension Card: Comparable {
    static func compare(_ lhs: [Card], _ operation: (Int, Int) -> Bool, _ rhs: [Card]) -> Bool {
        var leftCards = lhs.map { $0.rank.rawValue }.reduce(0, +)
        var rightCards = rhs.map { $0.rank.rawValue }.reduce(0, +)
        if leftCards != rightCards {
            return operation(leftCards, rightCards)
        }
        
        leftCards += lhs.map { $0.suit.rawValue }.reduce(0, +)
        rightCards += rhs.map { $0.suit.rawValue }.reduce(0, +)
        
        return operation(leftCards, rightCards)
    }
    
    static func < (lhs: Card, rhs: Card) -> Bool {
        if lhs.rank == rhs.rank {
            return lhs.suit < rhs.suit
        }
        
        return lhs.rank < rhs.rank
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        lhs.rank == rhs.rank && lhs.suit == rhs.suit
    }
}
