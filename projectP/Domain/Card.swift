//
//  Poker.swift
//  projectP
//
//  Created by Wender on 04/07/23.
//

import Foundation

// MARK: - Card logic
struct Card: Comparable, CustomStringConvertible {
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
    
    static func compare(_ lhs: [Card], _ operation: (Int8, Int8) -> Bool, _ rhs: [Card]) -> Bool {
        let leftCards = lhs.map { $0.rank.rawValue + $0.suit.rawValue }.reduce(0, +)
        let rightCards = rhs.map { $0.rank.rawValue + $0.suit.rawValue }.reduce(0, +)
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
    
    var description: String {
        "\(rank)\(suit)"
    }
}

extension Card {
    // MARK: - Rank logic
    
    enum Rank: Int8, Comparable, CustomStringConvertible {
        case two = 2, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace
        
        init?(_ value: String) {
            let ranks: [String: Rank] = ["2": .two, "3": .three, "4": .four, "5": .five, "6": .six, "7": .seven, "8": .eight, "9": .nine, "10": .ten, "J": .jack, "Q": .queen, "K": .king, "A": .ace]
            self.init(rawValue: ranks[value]!.rawValue)
        }
        
        static func < (lhs: Card.Rank, rhs: Card.Rank) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        
        static func == (lhs: Card.Rank, rhs: Card.Rank) -> Bool {
            lhs.rawValue == rhs.rawValue
        }
        
        var description: String {
            if self.rawValue <= 10 { return String(self.rawValue) }
            let values: [Rank: String] = [.jack: "J", .queen: "Q", .king: "K", .ace: "A"]
            return values[self] ?? "?"
        }
    }
    
}

extension Card {
    // MARK: - Suit logic
    
    enum Suit: Int8, Comparable, CustomStringConvertible {
        case spade = 4, heart = 3, club = 2, diamond = 1
        
        init?(_ value: String) {
            let suits: [String: Suit] = ["♣️": .club, "♦️": .diamond, "♠️": .spade, "♥️": .heart]
            self.init(rawValue: suits[value]!.rawValue)
        }
        
        static func < (lhs: Card.Suit, rhs: Card.Suit) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        
        static func == (lhs: Card.Suit, rhs: Card.Suit) -> Bool {
            lhs.rawValue == rhs.rawValue
        }
        
        var description: String {
            let values: [Suit: String] = [.spade: "♠️", .heart: "♥️", .club: "♣️", .diamond: "♦️" ]
            return values[self] ?? "?"
        }
        
    }
}
