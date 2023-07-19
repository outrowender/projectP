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
                Text("Pot: \(vm.table.pot)CR")
                DeckView(deck: vm.table.cards, empty: 5 - vm.table.cards.count)
            }

            VStack {

                HStack {
                    
                    VStack(alignment: .leading) {
                        Text("Player1 - \(vm.player1.credits)CR")
                        Text(vm.player1.hands.description)
                        DeckView(empty: vm.player1.hands.count)
                    }.padding(.all)
                    
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Player2 - \(vm.player2.credits)CR")
                        Text(vm.player2.hands.description)
                        DeckView(empty: vm.player2.hands.count)
                    }.padding(.all)
                }
                
                Spacer()
            }
            
            VStack {
                
                Spacer()
                
                HStack {
                    
                    VStack(alignment: .leading) {
                        Text("\(vm.player0.credits)CR")
                        DeckView(deck: vm.player0.hands)
                        Text(vm.p1Deck?.hand.description ?? "?")
                        Text("\(vm.p1Deck?.strength ?? 0)% Win")
                    }.padding(.all)
                    
                    Spacer()
                    
                    HStack {
                        Button("Call") {
                            vm.action(.call)
                        }
                            .buttonStyle(.bordered)
                        Button("Fold") {
                            vm.action(.fold)
                        }
                            .buttonStyle(.bordered)
                        Button("Raise") {
                            vm.action(.bet(amount: 10))
                        }
                            .buttonStyle(.bordered)
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
