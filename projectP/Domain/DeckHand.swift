//
//  DeckHand.swift
//  projectP
//
//  Created by Wender on 14/07/23.
//

import Foundation

extension Deck {
    
    enum Hand: Comparable, CustomStringConvertible {
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
        
        var description: String {
            switch (self) {
            case .highCard(_) :
                return "High Card"
            case .pair(_):
                return "Pair"
            case .twoPairs(_):
                return "Two Pairs"
            case .threeOfAKind(_):
                return "Three of a kind"
            case .straight(_):
                return "Straight"
            case .flush(_):
                return "Flush"
            case .fullHouse(_):
                return "Full House"
            case .fourOfAKind(_):
                return "Four of a Kind"
            case .straightFlush(_):
                return "Straight Flush"
            case .royalFlush(_):
                return "Royal Flush"
            }
        }
    }
}
