//
//  Deck.swift
//  projectP
//
//  Created by Wender on 04/07/23.
//

import Foundation

// MARK: - Deck logic
struct Deck: Comparable {
    
    let all: [Card]
    let table: [Card]
    let ours: [Card]
    private(set) var hand: Hand!
    
    init(_ table: [Card], ours: [Card]) {
        self.table = table
        self.ours = ours
        self.all = (table + ours).sorted { $0 > $1 }
        self.hand = compute(self.all)
    }
    
    init(_ table: String?, ours: String) {
        let literalTable: [Card] = table == nil ? [] : table!.components(separatedBy: " ").map { Card($0) }
        let literalOurs = ours.components(separatedBy: " ").map { Card($0) }
        self.init(literalTable, ours: literalOurs)
    }
    
    // MARK: - Compute logic
    private func compute(_ cards: [Card]) -> Hand {
        
        if let match = isRoyalFlush(cards) {
            return .royalFlush(match)
        }
        
        if let match = isStraightFlush(cards) {
            return .straightFlush(match)
        }
        
        if let match = isKind(of: 4, for: cards) {
            return .fourOfAKind(match)
        }
        
        if let match = isFullHouse(cards) {
            return .fullHouse(match)
        }
        
        if let match = isFlush(cards) {
            return .flush(match)
        }
        
        if let match = isStraight(cards) {
            return .straight(match)
        }
        
        if let match = isKind(of: 3, for: cards) {
            return .threeOfAKind(match)
        }
        
        if let match = isTwoPairs(cards) {
            return .twoPairs(match)
        }
        
        if let match = isKind(of: 2, for: cards) {
            return .pair(match)
        }
        
        return .highCard(cards.first!)
    }
    
    var strength: Double {
        var remainings: [Card] = []

        for rank in Card.Rank.allCases {
            for suit in Card.Suit.allCases {
                let card = Card(rank, suit)
                if self.all.contains(where: { $0 == card }) { continue }
                remainings.append(card)
            }
        }

        var ahead = 0, tied = 0, behind = 0

        let oppCombinations: [[Card]] = generateOpponentCardCombinations(remainingCards: remainings)
        
        let ourRank = self.hand!
        for oppCards in oppCombinations {
            let oppRank = compute(oppCards + self.table)

            if ourRank > oppRank {
                ahead += 1
            } else if ourRank == oppRank {
                tied += 1
            } else {
                behind += 1
            }
        }

        let handStrength = (Double(ahead) + Double(tied) / 2) / Double(ahead + tied + behind)
        return handStrength.rounded(toPlaces: 2)
    }
    
    private func generateOpponentCardCombinations(remainingCards: [Card]) -> [[Card]] {
        var combinations: [[Card]] = []
        
        for i in 0..<remainingCards.count {
            for j in (i + 1)..<remainingCards.count {
                let combination = [remainingCards[i], remainingCards[j]]
                combinations.append(combination)
            }
        }
        
        return combinations
    }
    
    static func bestHands(_ hands: [Hand]) -> Hand? {
        
        if let hand = hands.max(by: { $0.ranking < $1.ranking }) {
            return hand
        }
        
        return nil
    }
}
 
extension Deck {
    // Check if N cards are on the same kind
    private func isKind(of n: Int, for cards: [Card]) -> [Card]? {
        var count = [Card.Rank: [Card]]()
        
        for card in cards {
            count[card.rank, default: []].append(card)
        }
        
        let firstPair = count.first { (k, v) in v.count == n } // TODO: check logic for biggest cards first
        
        return firstPair?.value.sorted { $0 > $1 }
    }
    
    // Check if two pairs of same kind exists
    private func isTwoPairs(_ cards: [Card]) -> [Card]? {
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
    private func isStraight(_ cards: [Card]) -> [Card]? {
        let sequence = rankSequence(cards)
        if sequence.count < 5 { return nil }
        
        return Array(sequence[0..<5])
    }
    
    // Any five cards of the same suit, but not in a sequence
    private func isFlush(_ cards: [Card]) -> [Card]? {
        let sequence = suitSequence(cards)
        if sequence.count < 5 { return nil }
        
        return Array(sequence[0..<5])
    }
    
    // Five cards in a sequence, all in the same suit
    private func isStraightFlush(_ cards: [Card]) -> [Card]? {
        let ranks = rankSequence(cards)
        if ranks.count < 5 { return nil }
        let sequence = suitSequence(ranks)
        if sequence.count < 5 { return nil }
        
        return Array(sequence[0..<5])
    }
    
    // Three of a kind with a pair
    private func isFullHouse(_ cards: [Card]) -> [Card]? {
        guard let three = isKind(of: 3, for: cards) else { return nil }
        let remaining = cards.filter { !three.contains($0) }
        guard let pair = isKind(of: 2, for: remaining) else { return nil }
        
        return three + pair
    }
    
    // A, K, Q, J, 10, all the same suit
    private func isRoyalFlush(_ cards: [Card]) -> [Card]? {
        guard let straightFlush = isStraightFlush(cards) else { return nil }
        if straightFlush.first?.rank != .ace { return nil }
        
        return straightFlush
    }
    
    // How many cards are in sequence by suits [.club, .club, .club, ...]
    private func suitSequence(_ from: [Card]) -> [Card] {
        var sequence: [Card.Suit: Int8] = [:]
        
        for card in from {
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
        
        return from.filter { $0.suit == maxSuit }.sorted { $0 > $1 }
    }
    
    // How many cards are in sequence by ranks [9, 8, 7, ...]
    private func rankSequence(_ cards: [Card]) -> [Card] {
        var sequence = [Card]()
        
        for i in 1..<cards.count {
            if cards[i-1].rank.rawValue == (cards[i].rank.rawValue * 2) {
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
                return lhs.ranking < rhs.ranking
            }
        }
        
        static func > (lhs: Deck.Hand, rhs: Deck.Hand) -> Bool {
            switch (lhs, rhs) {
            case (.highCard(let lcard), .highCard(let rcard)):
                return lcard > rcard
            case (.pair(let lcards), .pair(let rcards)):
                return Card.compare(lcards, >, rcards)
            case (.twoPairs(let lcards), .twoPairs(let rcards)):
                return Card.compare(lcards, >, rcards)
            case (.threeOfAKind(let lcards), .threeOfAKind(let rcards)):
                return Card.compare(lcards, >, rcards)
            case (.straight(let lcards), .straight(let rcards)):
                return Card.compare(lcards, >, rcards)
            case (.flush(let lcards), .flush(let rcards)):
                return Card.compare(lcards, >, rcards)
            case (.fullHouse(let lcards), .fullHouse(let rcards)):
                return Card.compare(lcards, >, rcards)
            case (.fourOfAKind(let lcards), .fourOfAKind(let rcards)):
                return Card.compare(lcards, >, rcards)
            case (.straightFlush(let lcards), .straightFlush(let rcards)):
                return Card.compare(lcards, >, rcards)
            case (.royalFlush(let lcards), .royalFlush(let rcards)):
                return Card.compare(lcards, >, rcards)
            default:
                return lhs.ranking > rhs.ranking
            }
        }
        
        static func == (lhs: Deck.Hand, rhs: Deck.Hand) -> Bool {
            switch (lhs, rhs) {
            case (.highCard(let lcard), .highCard(let rcard)):
                return lcard == rcard
            case (.pair(let lcards), .pair(let rcards)):
                return Card.compare(lcards, ==, rcards)
            case (.twoPairs(let lcards), .twoPairs(let rcards)):
                return Card.compare(lcards, ==, rcards)
            case (.threeOfAKind(let lcards), .threeOfAKind(let rcards)):
                return Card.compare(lcards, ==, rcards)
            case (.straight(let lcards), .straight(let rcards)):
                return Card.compare(lcards, ==, rcards)
            case (.flush(let lcards), .flush(let rcards)):
                return Card.compare(lcards, ==, rcards)
            case (.fullHouse(let lcards), .fullHouse(let rcards)):
                return Card.compare(lcards, ==, rcards)
            case (.fourOfAKind(let lcards), .fourOfAKind(let rcards)):
                return Card.compare(lcards, ==, rcards)
            case (.straightFlush(let lcards), .straightFlush(let rcards)):
                return Card.compare(lcards, ==, rcards)
            case (.royalFlush(let lcards), .royalFlush(let rcards)):
                return Card.compare(lcards, ==, rcards)
            default:
                return lhs.ranking == rhs.ranking
            }
        }
    }
}
