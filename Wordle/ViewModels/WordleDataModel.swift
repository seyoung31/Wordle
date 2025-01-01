//
//  WordleDataModel.swift
//  Wordle
//
//  Created by Seyoung on 2022/07/30.
//

import SwiftUI

class WordleDataModel: ObservableObject {
    @Published var guesses: [Guess] = [] // empty array of guesses
    @Published var incorrectAttempts = [Int](repeating: 0, count: 6)
    @Published var toastText: String?
    @Published var showStats = false
    
    var keyColors = [String: Color]()
    var matchedLetters = [String]()
    var misplacedLetters = [String]()
    var selectedWord = ""
    var currentWord = ""
    var tryIndex = 0 // number of attempts
    var inPlay = false
    var gameOver = false
    var toastWords = ["Genius", "Magnificent", "Impressive", "Splendid", "Great", "Phew"]
    var currentStat: Statistic
    
    var gameStarted: Bool {
        !currentWord.isEmpty || tryIndex > 0 // if the current word is not empty OR the user made a guess
    }
    
    var disabledKeys: Bool {
        !inPlay || currentWord.count == 5 // disable keyboard when the game has not started OR the entered word has length of 5
    }
    
    init() {
        currentStat = Statistic.loadSet()
        newGame()
    }
    
    // MARK: - Setup
    func newGame() {
        tryIndex = 0 
        populateDefaults()
        selectedWord = Global.commonWords.randomElement()! // get a random word from the list
        currentWord = ""
        inPlay = true
        print(selectedWord)
    }
    
    func populateDefaults() {
        guesses = [] // empty the array for every game
        for index in 0...5 {
            guesses.append(Guess(index: index)) // append new guesses using the loop's index
        }
        
        // reset keyboard colors
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" // used for the KEYCOLORS dictionary keys
        for char in letters {
            keyColors[String(char)] = .unused // default color for unused color
        }
        matchedLetters = []
        misplacedLetters = []
    }
    
    // MARK: - Game Play
    func addToCurrentWord(_ letter: String) {
        currentWord += letter
        updateRow()
    }
    
    func enterWord() {
        if currentWord == selectedWord {
            gameOver = true
            print("You WIN")
            setCurrentGuessColors()
            currentStat.update(win: true, index: tryIndex)
            showToast(with: toastWords[tryIndex])
            inPlay = false
        } else {
            if verifyWord() {
                print("Valid Word")
                setCurrentGuessColors()
                tryIndex += 1 // move on to the next row
                currentWord = ""
                if tryIndex == 6 {
                    currentStat.update(win: false)
                    gameOver = true
                    inPlay = false
                    showToast(with: selectedWord)
                    print("You lose")
                }
            } else {
                // invalid word
                withAnimation{
                self.incorrectAttempts[tryIndex] += 1
                }
                showToast(with: "Not in word list.")
                incorrectAttempts[tryIndex] = 0
            }
        }
    }
    
    func removeLetterFromCurrentWord() {
        currentWord.removeLast()
        updateRow()
    }
    
    func updateRow() {
        // check if a five length word was typed in
        let guessWord = currentWord.padding(toLength: 5, withPad: " ", startingAt: 0)
        guesses[tryIndex].word = guessWord
    }
    
    // use existing dictionary
    func verifyWord() -> Bool {
        UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: currentWord)
    }
    
    // call this function when we win
    func setCurrentGuessColors() {
        let correctLetters = selectedWord.map { String($0) }
        var frequency = [String: Int]()
        // increment the frequency for each letter in the correct word
        for letter in correctLetters {
            frequency[letter, default: 0] += 1
        }
        for index in 0...4 {
            let correctLetter = correctLetters[index]
            let guessLetter = guesses[tryIndex].guessLetters[index] // from 5x6 grid
            if guessLetter == correctLetter {
                guesses[tryIndex].bgColors[index] = .correct
                if !matchedLetters.contains(guessLetter) {
                    matchedLetters.append(guessLetter)
                    keyColors[guessLetter] = .correct
                }
                if misplacedLetters.contains(guessLetter) {
                    if let index = misplacedLetters.firstIndex(where: {$0 == guessLetter}) {
                        misplacedLetters.remove(at: index)
                    }
                }
                frequency[guessLetter]! -= 1
            }
        }
        
        for index in 0...4 {
            let guessLetter = guesses[tryIndex].guessLetters[index]
            if correctLetters.contains(guessLetter)
                && guesses[tryIndex].bgColors[index] != .correct
                && frequency[guessLetter]! > 0 {
                    guesses[tryIndex].bgColors[index] = .misplaced
                    if !misplacedLetters.contains(guessLetter) && !matchedLetters.contains(guessLetter) {
                        misplacedLetters.append(guessLetter)
                        keyColors[guessLetter] = .misplaced
                }
                frequency[guessLetter]! -= 1
            }
        }
        
        for index in 0...4 {
            let guessLetter = guesses[tryIndex].guessLetters[index]
            if keyColors[guessLetter] != .correct
                && keyColors[guessLetter] != .misplaced {
                keyColors[guessLetter] = .wrong
            }
        }
        flipCards(for: tryIndex)
    }
    
    func flipCards(for row: Int) {
        for col in 0...4 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(col) * 0.2) {
                self.guesses[row].cardFlipped[col].toggle()
            }
        }
    }
    
    func showToast(with text: String?) {
        withAnimation {
            toastText = text
        }
        withAnimation(Animation.linear(duration: 0.2).delay(3)) {
            toastText = nil
            if gameOver {
                withAnimation(Animation.linear(duration: 0.2).delay(3)) {
                    showStats.toggle()
                }
            }
        }
    }
}

