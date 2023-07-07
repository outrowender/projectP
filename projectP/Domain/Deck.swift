//
//  Deck.swift
//  projectP
//
//  Created by Wender on 04/07/23.
//

import Foundation

// MARK: - Deck logic
struct Deck: Comparable {
    
    let cards: [Card]
    private(set) var hand: Hand?
    
    init(_ cards: [Card]) {
        self.cards = cards.sorted { $0 > $1 }
        self.hand = compute()
    }
    
    init(_ literal: String) {
        let literalArray = literal.components(separatedBy: " ").map { Card($0) }
        self.init(literalArray)
    }
    
    // MARK: - Compute logic
    private func compute() -> Hand {
        
        if let match = isRoyalFlush() {
            return .royalFlush(match)
        }
        
        if let match = isStraightFlush() {
            return .straightFlush(match)
        }
        
        if let match = isKind(of: 4) {
            return .fourOfAKind(match)
        }
        
        if let match = isFullHouse() {
            return .fullHouse(match)
        }
        
        if let match = isFlush() {
            return .flush(match)
        }
        
        if let match = isStraight() {
            return .straight(match)
        }
        
        if let match = isKind(of: 3) {
            return .threeOfAKind(match)
        }
        
        if let match = isTwoPairs() {
            return .twoPairs(match)
        }
        
        if let match = isKind(of: 2) {
            return .pair(match)
        }
        
        return .highCard(cards.first!)
    }
}
 
extension Deck {
    // Check if N cards are on the same kind
    private func isKind(of n: Int, from: [Card]? = nil) -> [Card]? {
        let cards = from ?? self.cards
        
        var count = [Card.Rank: [Card]]()
        
        for card in cards {
            count[card.rank, default: []].append(card)
        }
        
        let firstPair = count.first { (k, v) in v.count == n } // TODO: check logic for biggest cards first
        
        return firstPair?.value.sorted { $0 > $1 }
    }
    
    // Check if two pairs of same kind exists
    private func isTwoPairs() -> [Card]? {
        var count = [Card.Rank: [Card]]()
        
        for card in cards {
            count[card.rank, default: []].append(card)
        }
        
        let pairs = count.filter { (k, v) in v.count == 2 }
        
        if pairs.count >= 2 {
            let sortedPairs = pairs.values.sorted { $0[0] > $1[0] }
            return sortedPairs[0] + sortedPairs[1]
        }
        
        return nil
    }
    
    // Check if cards in a sequence, but not of the same suit
    private func isStraight() -> [Card]? {
        let sequence = rankSequence()
        if sequence.count < 5 { return nil }
        
        return Array(sequence[0..<5])
    }
    
    // Any five cards of the same suit, but not in a sequence
    private func isFlush() -> [Card]? {
        let sequence = suitSequence()
        if sequence.count < 5 { return nil }
        
        return Array(sequence[0..<5])
    }
    
    // Five cards in a sequence, all in the same suit
    private func isStraightFlush() -> [Card]? {
        let ranks = rankSequence()
        if ranks.count < 5 { return nil }
        
        let sequence = suitSequence(ranks)
        if sequence.count < 5 { return nil }
        
        return Array(sequence[0..<5])
    }
    
    // Three of a kind with a pair
    private func isFullHouse() -> [Card]? {
        guard let three = isKind(of: 3) else { return nil }
        
        let remaining = cards.filter { !three.contains($0) }
        
        guard let pair = isKind(of: 2, from: remaining) else { return nil }
        
        return three + pair
    }
    
    // A, K, Q, J, 10, all the same suit
    private func isRoyalFlush() -> [Card]? {
        guard let straightFlush = isStraightFlush() else { return nil }
        
        if straightFlush.first?.rank != .ace { return nil }
        
        return straightFlush
    }
    
    // How many cards are in sequence by suits [.club, .club, .club, ...]
    private func suitSequence(_ from: [Card]? = nil) -> [Card] {
        let cards = from ?? self.cards
        
        var sequence: [Card.Suit: Int8] = [:]
        
        for card in cards {
            sequence[card.suit, default: 0] += 1
        }

        var maxSuit: Card.Suit? = nil
        var maxValue: Int8 = Int8.min

        for (suit, value) in sequence {
            if value > maxValue {
                maxSuit = suit
                maxValue = value
            }
        }
        
        guard let maxSuit else { return [] }
        
        return cards.filter { $0.suit == maxSuit }.sorted { $0 > $1 }
    }
    
    // How many cards are in sequence by ranks [9, 8, 7, ...]
    private func rankSequence() -> [Card] {
        var sequence = [Card]()
        
        for i in 1..<cards.count {
            if cards[i-1].rank.rawValue == (cards[i].rank.rawValue + 1) {
                if sequence.isEmpty {
                    sequence.append(cards[i-1])
                }
                sequence.append(cards[i])
            }
        }
        
        return sequence.sorted { $0 > $1 }
    }
    
    public static func < (lhs: Deck, rhs: Deck) -> Bool {
        lhs.hand! < rhs.hand!
    }
}

extension Deck {
    
    enum Hand: Comparable {
        
        case highCard(Card),
             pair([Card]),
             twoPairs([Card]),
             threeOfAKind([Card]),
             straight([Card]),
             flush([Card]),
             fullHouse([Card]),
             fourOfAKind([Card]),
             straightFlush([Card]),
             royalFlush([Card])
        
        var ranking: Int8 {
            switch self {
            case .highCard(_): return 1
            case .pair(_): return 2
            case .twoPairs(_): return 3
            case .threeOfAKind(_): return 4
            case .straight(_): return 5
            case .flush(_): return 6
            case .fullHouse(_): return 7
            case .fourOfAKind(_): return 8
            case .straightFlush(_): return 9
            case .royalFlush(_): return 10
            }
        }
        
        static func < (lhs: Deck.Hand, rhs: Deck.Hand) -> Bool {
            switch (lhs, rhs) {
            case (.highCard(let lcard), .highCard(let rcard)):
                return lcard < rcard
            case (.pair(let lcards), .pair(let rcards)):
                return Card.compare(lcards, <, rcards)
            case (.twoPairs(let lcards), .twoPairs(let rcards)):
                return Card.compare(lcards, <, rcards)
            case (.threeOfAKind(let lcards), .threeOfAKind(let rcards)):
                return Card.compare(lcards, <, rcards)
            case (.straight(let lcards), .straight(let rcards)):
                return Card.compare(lcards, <, rcards)
            case (.flush(let lcards), .flush(let rcards)):
                return Card.compare(lcards, <, rcards)
            case (.fullHouse(let lcards), .fullHouse(let rcards)):
                return Card.compare(lcards, <, rcards)
            case (.fourOfAKind(let lcards), .fourOfAKind(let rcards)):
                return Card.compare(lcards, <, rcards)
            case (.straightFlush(let lcards), .straightFlush(let rcards)):
                return Card.compare(lcards, <, rcards)
            case (.royalFlush(let lcards), .royalFlush(let rcards)):
                return Card.compare(lcards, <, rcards)
            default:
                return false
            }
        }
    }
}
