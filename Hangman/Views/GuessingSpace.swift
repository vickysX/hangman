//
//  GuessingSpace.swift
//  Hangman
//
//  Created by Vittorio Sassu on 21/01/24.
//

import SwiftUI

struct GuessingSpace: View {
    @State private var showingDefinition = false
    @State private var usedLetters = [String]()
    
    @State private var showingInvalidLetterAlert = false
    @State private var invalidLetterMessage = ""
    
    @State private var showingGuessedWordAlert = false
    
    @State private var wordInUnderscores = [String]()
    
    var word: Word
    
    var wordToBeGuessed: String {
        wordInUnderscores
            .joined(separator: " ")
            .trimmingCharacters(in: .whitespaces)
    }
    
    var body: some View {
        VStack {
            Text(wordToBeGuessed)
            if showingDefinition {
                Definition(
                    wordDefinition: word.definition,
                    definitionSource: word.definitionSource
                )
            }
            UsedLetters(usedLetters: usedLetters)
        }
        .onAppear(perform: startGuessing)
        .alert("Invalid input", isPresented: $showingInvalidLetterAlert) {
            Button("OK") {}
        } message: {
            Text(invalidLetterMessage)
        }
        .alert("", isPresented: $showingGuessedWordAlert) {
            Button("Continue") {}
        } message: {
            Text("Congratulations, \(word.entry) was the correct word!")
        }
    }
    
    func startGuessing() {
        wordInUnderscores = [String](
            repeating: "_",
            count: word.entry.count
        )
    }
    
    func accept(input letter: String) {
        guard usedLetters.doesNotContain(letter) else {
            invalidLetterMessage = "You already tried this letter."
            return
        }
        
        guard letter.isLetterOrHyphen else {
            invalidLetterMessage = "Invalid character. You can only insert a letter or a hyphen."
            return
        }
        
        guard doesWordContain(input: letter) else {
            usedLetters.append(letter)
            return
        }
        
        insert(input: letter)
        
        guard isWordGuessed() else {
            return
        }
        
        showingGuessedWordAlert = true
        
        // TODO: Implement some score logic
    }
    
    func isValid(input letter: String) -> Bool {
        letter.isLetterOrHyphen || !usedLetters.contains(letter)
    }
    
    func doesWordContain(input letter: String) -> Bool {
        word.entry.contains(letter)
    }
    
    func insert(input letter: String) {
        if word.entry.firstIndex(of: Character(letter)) == word.entry.lastIndex(of: Character(letter)) {
            if let index = word.entry.split(separator: "").firstIndex(of: String.SubSequence(letter)) {
                wordInUnderscores[index] = letter
            }
        } else {
            // Use an ArraySlice<String.SubSequence> object
            var copy = word.entry.split(separator: "").suffix(from: 0)
            while copy.contains(String.SubSequence(letter)) {
                if let index = copy.firstIndex(of: String.SubSequence(letter)) {
                    wordInUnderscores[index] = letter
                    copy = copy.suffix(from: index + 1)
                }
            }
        }
    }
    
    func isWordGuessed() -> Bool {
        !wordToBeGuessed.contains("_")
    }
}

#Preview {
    GuessingSpace(word: Word(id: 0, entry: "io", definition: "Ciao, sono una definizione da dizionario", definitionSource: "Treccani", level: .easy))
}