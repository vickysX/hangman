//
//  GuessingSpace.swift
//  Hangman
//
//  Created by Vittorio Sassu on 21/01/24.
//

import SwiftUI
import SwiftData

struct GuessingScreen: View {
    
    @State private var showingDefinition = false
    @State private var usedLetters = [String]()
    
    @State private var letterSelection = "m"
    
    @State private var wholeWordGuess = ""
    
    @State private var showingInvalidLetterAlert = false
    @State private var invalidLetterMessage = ""
    
    @State private var showingWrongWholeWordAlert = false
    
    @State private var showingGuessedWordAlert = false
    
    @State private var wordInUnderscores = [String]()
    
    var word: Word
    @Bindable var game: Game
    
    let allLetters = Array("abcdefghijklmnopqrstuvwxyz")
    
    var wordToBeGuessed: String {
        wordInUnderscores
            .joined(separator: " ")
            .trimmingCharacters(in: .whitespaces)
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Form {
                Text(wordToBeGuessed)
                    .font(.largeTitle)
                    .padding()
                    .frame(alignment: .center)
                Section("Choose a letter") {
                    Picker("Select a letter", selection: $letterSelection) {
                        ForEach(allLetters, id: \.self) { letter in
                            Text(String(letter))
                        }
                    }
                    .pickerStyle(.wheel)
                }
                Section {
                    TextField("Try to guess the whole word", text: $wholeWordGuess)
                }
                Section {
                    Button {
                        showingDefinition.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "lightbulb")
                            Text("Hint")
                        }
                    }
                    .popover(isPresented: $showingDefinition, attachmentAnchor: .point(.center),
                             arrowEdge: .top
                    ) {
                        Definition(wordDefinition: word.definition, definitionSource: word.definitionSource)
                            .presentationCompactAdaptation(.popover)
                            .onTapGesture {
                                showingDefinition.toggle()
                            }
                    }
                }
                UsedLetters(usedLetters: usedLetters)
            }
            
        }
        .onAppear(perform: startGuessing)
        .alert("Stupid input", isPresented: $showingInvalidLetterAlert) {
            Button("OK") {}
        } message: {
            Text(invalidLetterMessage)
        }
        .alert("You guessed!", isPresented: $showingGuessedWordAlert) {
            Button("Continue") {}
        } message: {
            Text("Congratulations, \(word.entry) was the correct word!")
        }
        .alert("Nice try", isPresented: $showingWrongWholeWordAlert) {
            Button("OK") {
                wholeWordGuess = ""
            }
        } message: {
            Text("Sorry, \(wholeWordGuess) is not the correct word. Kudos to your braveness")
        }
        .toolbar {
            Button("Guess") {
                guard wholeWordGuess.isEmpty else {
                    acceptWholeWord()
                    return
                }
                accept(letter: letterSelection)
            }
        }
    }
    
    func startGuessing() {
        if !word.entry.contains("-") {
            wordInUnderscores = [String](
                repeating: "_",
                count: word.entry.count
            )
        } else {
            for char in word.entry {
                if String(char).isLetter {
                    wordInUnderscores.append("_")
                } else {
                    wordInUnderscores.append(String(char))
                }
            }
        }
    }
    
    func acceptWholeWord() {
        guard isWordGuessed() else {
            // TODO: Implement some kind of penalty
            showingWrongWholeWordAlert = true
            return
        }
        
        showingGuessedWordAlert = true
    }
    
    func accept(letter: String) {
        guard usedLetters.doesNotContain(letter) else {
            invalidLetterMessage = "You already tried this letter."
            return
        }
        
        guard letter.isLetter else {
            invalidLetterMessage = "Invalid character. You can only insert a letter."
            return
        }
        
        guard doesWordContain(input: letter) else {
            withAnimation {
                usedLetters.append(letter)
                game.score -= 1
            }
            return
        }
        
        insert(input: letter)
        game.score += 1
        
        guard isWordGuessed() else {
            return
        }
        
        showingGuessedWordAlert = true
        
    }
    
    func isValid(input letter: String) -> Bool {
        letter.isLetter || !usedLetters.contains(letter)
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
        !wordToBeGuessed.contains("_") || wholeWordGuess.lowercased() == word.entry.lowercased()
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Game.self, configurations: config)
        
        let word = Word(id: 0, entry: "io", definition: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ", definitionSource: "Treccani", level: .easy)
        let newGame = Game()
        
        return GuessingScreen(word: word, game: newGame)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create a model container")
    }
}
