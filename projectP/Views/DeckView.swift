//
//  DeckView.swift
//  projectP
//
//  Created by Wender on 13/07/23.
//

import SwiftUI

struct DeckView: View {
    
    let deck: [Card]
    let empty: Int
    
    init(deck: [Card], empty: Int = 0) {
        self.deck = deck
        self.empty = empty
    }
    
    init(empty: Int) {
        self.deck = []
        self.empty = empty
    }
    
    var body: some View {
        HStack {
            ForEach(deck, id: \.self) { card in
                CardView(card)
            }
            
            ForEach(0..<empty, id: \.self) { _ in
                BackCardView()
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView(deck: Card.array("A♠️ K♦️ Q♣️"), empty: 2)
    }
}
