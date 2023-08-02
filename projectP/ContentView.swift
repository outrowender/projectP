//
//  ContentView.swift
//  projectP
//
//  Created by Wender on 04/07/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var vm = GameVM()
    
    var body: some View {
        ZStack {
            
            VStack {
                if let winner = vm.winner {
                    Text("Winner: \(vm.table.players[winner].name)")
                }
                Text("Pot: \(vm.table.pot)CR")
                DeckView(deck: vm.table.cards, empty: 5 - vm.table.cards.count)
            }

            VStack {
                if vm.winner != nil {
                    HStack {
                        PlayerView(player: $vm.player2, index: 2, showHands: true, playing: $vm.player)
                        Spacer()
                        PlayerView(player: $vm.player1, index: 1, showHands: true, playing: $vm.player)
                    }
                } else {
                    HStack {
                        PlayerView(player: $vm.player2, index: 2, showHands: false, playing: $vm.player)
                        Spacer()
                        PlayerView(player: $vm.player1, index: 1, showHands: false, playing: $vm.player)
                    }
                }
                
                Spacer()
            }
            
            VStack {
                
                Spacer()
                
                HStack {
                    
                    VStack(alignment: .leading) {
                        Text(vm.player0.lastDecision?.description ?? "")
                        Text("\(vm.player0.credits)CR")
                        DeckView(deck: vm.player0.hands)
                        Text(vm.p1Deck?.hand.description ?? "?")
                        Text("\(vm.p1Deck?.strength ?? 0)% Win")
                    }.padding(.all)
                    
                    Spacer()
                    
                    VStack {
                        
                        if vm.player == 0 {
                            Button("Check") {
                                Task {
                                    await vm.action(.check)
                                }
                            }.buttonStyle(.bordered)
                            Button("Fold") {
                                Task {
                                    await vm.action(.fold)
                                }
                            }.buttonStyle(.bordered)
                            Button("Raise") {
                                Task {
                                    await vm.action(.bet(amount: 10))
                                }
                            }.buttonStyle(.bordered)
                        } else {
                            Text("wait")
                        }
                        
                        
                    }.padding(.all)
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
