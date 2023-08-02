//
//  GameViewModel.swift
//  projectP
//
//  Created by Wender on 13/07/23.
//

import Foundation

class GameVM: ObservableObject {
    
    @Published var player0: Player = Player(id: "me", name: "Wender", credits: 100)
    @Published var player1: Player = Player(id: "1", name: "CPU 1", credits: 100)
    @Published var player2: Player = Player(id: "2", name: "CPU 2", credits: 100)
    
    @Published var p1Deck: Deck?
    
    @Published var table: Table!
    @Published var player: Int = 0
    @Published var winner: Int?
    
    init() { // TODO: fix weird init
        
        self.table = Table(players: [player0, player1, player2])
        
        table.startGame()
        
        updatePlayers()
        
        table.playerIndex.subscribe { value in
            DispatchQueue.main.async {
                self.player = value
            }
        }
        
        table.winner.subscribe { value in
            DispatchQueue.main.async {
                self.winner = value
            }
        }
    }
    
    private func updatePlayers() {
        DispatchQueue.main.async { [self] in
            self.player0 = table.players[0]
            self.player1 = table.players[1]
            self.player2 = table.players[2]
            
            self.p1Deck = Deck(table.cards, ours: player0.hands)
            self.table = self.table
            self.player = self.table.playerIndex.value
        }
    }
    
    func action(_ decision: Player.Decision) async { // TODO: pass decision
        
        print(table.playerIndex.value, decision)

        if table.winner.value != nil {
            self.table.startGame()
            updatePlayers()
            return
        }

        table.play(table.playerIndex.value, decision: decision)
        try? await Task.sleep(for: .seconds(2))

        while table.playerIndex.value != 0 {
            let ai = AIPlayer(table.players[table.playerIndex.value])
            let decision = ai.decide(table: table.cards, pot: 0, opponents: 0)
            updatePlayers()
            await action(decision)
        }

        updatePlayers()
    }
}
