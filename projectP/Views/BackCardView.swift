//
//  BackCardView.swift
//  projectP
//
//  Created by Wender on 12/07/23.
//

import SwiftUI

struct BackCardView: View {
    var body: some View {
        VStack {
            VStack {
                Text("? ? ? ?")
                Text("? ¿ ?")
                Text("¿ ¿ ¿ ¿")
            }
            .frame(width: 50, height: 90)
            .foregroundColor(.gray)
        }
        .frame(width: 60, height: 90)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.foreground, lineWidth: 0.2)
        )
    }
}

struct BackCardView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            CardView(Card("A♠️"))
            BackCardView()
        }
        .padding(.all)
    }
}
