//
//  PlayerView.swift
//  projectP
//
//  Created by Wender on 25/07/23.
//

import SwiftUI

struct PlayerView: View {
    @Binding var player: Player
    let index: Int
    @State var showHands: Bool
    @Binding var playing: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(player.name)
                if index == playing {
                    ProgressView().padding(.leading)
                }
            }
            if showHands {
                HStack {
                    ForEach(player.hands, id: \.self) { card in
                        CardView(card)
                    }
                }
            } else {
                HStack(spacing: -20) {
                    ForEach(0..<player.hands.count, id: \.self) { index in
                        BackCardView()
                            .rotationEffect(.degrees(Double(index) * 15))
                    }
                }
            }
            Text("\(player.credits) CR")
            Text(player.lastDecision?.description ?? " ")
            
        }.padding(.all)
    }
}

struct PlayerView_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            HStack {
                PlayerView(player: .constant(Player(id: "a", name: "CPU 1", hands: Card.array("10♥️ 9♠️"), credits: 100)),
                           index: 0,
                           showHands: false,
                           playing: .constant(1))
                PlayerView(player: .constant(Player(id: "a", name: "CPU 1", hands: Card.array("10♥️ 9♠️"), credits: 100)),
                           index: 0,
                           showHands: false,
                           playing: .constant(0))
                PlayerView(player: .constant(Player(id: "a", name: "CPU 1", hands: Card.array("10♥️ 9♠️"), credits: 100)),
                           index: 0,
                           showHands: true,
                           playing: .constant(1))
                PlayerView(player: .constant(Player(id: "a", name: "CPU 1", hands: Card.array("10♥️ 9♠️"), lastDecision: .check, credits: 100)),
                           index: 0,
                           showHands: false,
                           playing: .constant(1))
            }
        }
        .previewLayout(.sizeThatFits)
    }
}
