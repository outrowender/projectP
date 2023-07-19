//
//  Rank.swift
//  projectP
//
//  Created by Wender on 14/07/23.
//

import Foundation

extension Card {
    // MARK: - Rank logic
    
    enum Rank: Int, CaseIterable, CustomStringConvertible {
        case two = 1, three = 2, four = 4, five = 8, six = 16, seven = 32, eight = 64, nine = 128, ten = 256, jack = 512, queen = 1024, king = 2048, ace = 4096
        
        init?(_ value: String) {
            let ranks: [String: Rank] = ["2": .two, "3": .three, "4": .four, "5": .five, "6": .six, "7": .seven, "8": .eight, "9": .nine, "10": .ten, "J": .jack, "Q": .queen, "K": .king, "A": .ace]
            self.init(rawValue: ranks[value]!.rawValue)
        }
        
        var int: Int {
            let values: [Rank: Int] = [.two: 2, .three: 3, .four: 4, .five: 5, .six: 6, .seven: 7, .eight: 8, .nine: 9, .ten: 10, .jack: 11, .queen: 12, .king: 13, .ace: 14]
            return values[self] ?? 0
        }
        
        var description: String {
            let values: [Rank: String] = [.two: "2", .three: "3", .four: "4", .five: "5", .six: "6", .seven: "7", .eight: "8", .nine: "9", .ten: "10", .jack: "J", .queen: "Q", .king: "K", .ace: "A"]
            return values[self] ?? "?"
        }
    }
    
}

extension Card.Rank: Comparable {
    static func < (lhs: Card.Rank, rhs: Card.Rank) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    static func == (lhs: Card.Rank, rhs: Card.Rank) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}

