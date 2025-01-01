//
//  LetterButtonView.swift
//  Wordle
//
//  Created by Seyoung on 2022/08/07.
//

import SwiftUI

struct LetterButtonView: View {
    @EnvironmentObject var dm: WordleDataModel
    var letter: String
    var body: some View {
        Button {
            dm.addToCurrentWord(letter)
        } label: {
            Text(letter)
                .font(.system(size:20))
                .frame(width: 35, height: 50)
                .background(dm.keyColors[letter]) // return the color from the dictionary by using the letter as the key
                .foregroundColor(.primary) // initially unused color
        }
        .buttonStyle(.plain)
    }
}

struct LetterButtonView_Previews: PreviewProvider {
    static var previews: some View {
        LetterButtonView(letter: "L")
            .environmentObject(WordleDataModel())
    }
}
