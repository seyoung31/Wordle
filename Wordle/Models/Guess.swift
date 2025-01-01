//
//  Guess.swift
//  Wordle
//
//  Created by Seyoung on 2022/07/06.
//

import SwiftUI

struct Guess {
    let index: Int
    var word = "     " // initially 5 spaces to represent 5 character word
    var bgColors = [Color](repeating: .wrong, count: 5)
    var cardFlipped = [Bool](repeating: false, count: 5) // cards are not flipped initially
    var guessLetters: [String] { // break down the array to iterate through each character converted to a string
        word.map { String($0) }
    }
    
}
