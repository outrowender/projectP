//
//  CardView.swift
//  projectP
//
//  Created by Wender on 12/07/23.
//

import SwiftUI

struct CardView: View {
    
    let card: Card
    
    init(_ card: Card) {
        self.card = card
    }
    
    var body: some View {
     
            VStack {
                HStack {
                    VStack {
                        Text(self.card.rank.description)
                            .font(.system(size: 20))
                            .foregroundColor(color)
                        Text(self.card.suit.description)
                            .font(.system(size: 10))
                            .foregroundColor(color)
                    }
                    
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Text(self.card.suit.description)
                        .font(.system(size: 40))
                        .foregroundColor(color)
                }
                
            }
            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
            .frame(width: 60, height: 90)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.foreground, lineWidth: 0.2)
            )
            

        
    }
    
    var color: Color {
        if card.suit.color == "B" {
            return .black
        } else {
            return .red
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            CardView(Card("A♠️"))
            CardView(Card("K♦️"))
            CardView(Card("Q♣️"))
            CardView(Card("10♥️"))
            BackCardView()
        }
        .padding(.all)
    }
}
