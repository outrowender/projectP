//
//  GameViewModel.swift
//  projectP
//
//  Created by Wender on 13/07/23.
//

import Foundation

class GameVM: ObservableObject {
    
    @Published var player0: Player = Player(id: "me", credits: 100)
    @Published var player1: Player = Player(id: "1", credits: 100)
    @Published var player2: Player = Player(id: "2", credits: 100)
    
    @Published var p1Deck: Deck?
    
    @Published var table: Table!
    
    init() { // TODO: fix weird init
        
        self.table = Table(players: [player0, player1, player2])
        
        table.startGame()
        
        updatePlayers()
    }
    
    private func updatePlayers() {
        self.player0 = table.players[0]
        self.player1 = table.players[1]
        self.player2 = table.players[2]
        
        self.p1Deck = Deck(table.cards, ours: player0.hands)
        self.table = self.table
    }
    
    func action(_ decision: Player.Decision) { // TODO: pass decision
//        let next = table.takeTurn(player: player0, decision: decision)
        
//        if next != player0 {
//            let ai = AIPlayer(next)
//            let decision = ai.decide(table: table.dealer, pot: table.pot, opponents: table.players.count)
//            print(decision)
//
//            action(decision)
//        }
//
//        updatePlayers()
    }
}
