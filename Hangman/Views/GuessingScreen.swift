//
//  GuessingSpace.swift
//  Hangman
//
//  Created by Vittorio Sassu on 21/01/24.
//

import SwiftUI
import SwiftData

struct GuessingScreen: View {
    @Environment(ModelData.self) var modelData
    @Environment(\.modelContext) var context
    
    @State private var showingDefinition = false
    @State private var usedLetters = [String]()
    
    @State private var letterSelection = ""
    
    @State private var wholeWordGuess = ""
    
    @State private var showingInvalidLetterAlert = false
    @State private var invalidLetterMessage = ""
    
    @State private var showingWrongWholeWordAlert = false
    
    @State private var showingGuessedWordAlert = false
    
    @State private var wordOptional: Word? = nil
    
    @State private var wordInUnderscores = [String]()
    
    @Bindable var game: Game
    @Binding var isGameFinished: Bool
    @Binding var isGameOver: Bool
    
    let allLetters = Array("abcdefghijklmnopqrstuvwxyz").map {
        String($0)
    }
    
    var word: Word {
        if let theWord = wordOptional {
            return theWord
        } else {
            return modelData.words[0]
        }
    }
    
    var wordToBeGuessed: String {
        wordInUnderscores
            .joined(separator: " ")
            .trimmingCharacters(in: .whitespaces)
    }
    
    var scoreIncrementBasedOnLevel: Int {
        switch word.level {
        case .easy:
            1
        case .medium, .difficult:
            2
        }
    }
    
    var wrongGuessesInScorePoints: Int {
        usedLetters.count / scoreIncrementBasedOnLevel
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Form {
                Section {
                    Text(wordToBeGuessed)
                        .font(.largeTitle)
                        .padding()
                        .frame(alignment: .center)
                }
                Section("Choose a letter") {
                    Picker("Select a letter", selection: $letterSelection) {
                        ForEach(allLetters, id: \.self) { letter in
                            Text(String(letter))
                        }
                    }
                    .pickerStyle(.wheel)
                }
                Section("Do you think you're smart?") {
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
        .onAppear(perform: {
            context.insert(game)
            startGuessing()
        })
        .alert("Stupid input", isPresented: $showingInvalidLetterAlert) {
            Button("OK") {}
        } message: {
            Text(invalidLetterMessage)
        }
        .alert("You guessed!", isPresented: $showingGuessedWordAlert) {
            Button("Continue") {
                startGuessing()
            }
        } message: {
            Text("Congratulations, \(word.entry) was the correct word!")
        }
        .alert("Nice try", isPresented: $showingWrongWholeWordAlert) {
            Button("OK") {
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
        print(game.score)
        print(game.numWords)
        print(game.level)
        
        guard !game.isFinished else {
            isGameFinished = true
            return
        }
        
        guard !game.isOver else {
            isGameOver = true
            return
        }
        
        print("Loading new word...")
        
        wordOptional = game.chooseWordToGuess(from: modelData.words)
        print(wordOptional)
        print("Chosen word: \(word.entry)")
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
            showingWrongWholeWordAlert = true
            return
        }
        
        withAnimation {
            usedLetters = []
            wholeWordGuess = ""
        }
        
        game.score += word.entry.count + scoreIncrementBasedOnLevel
        game.numWords += 1
        game.goToNextLevel()
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
                game.score -= scoreIncrementBasedOnLevel
            }
            return
        }
        
        insert(input: letter)
        game.score += scoreIncrementBasedOnLevel
        
        guard isWordGuessed() else {
            return
        }
        
        withAnimation {
            usedLetters = []
        }
        
        showingGuessedWordAlert = true
        game.numWords += 1
        if wrongGuessesInScorePoints <= 6 {
            game.goToNextLevel()
        }
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
        print(wordInUnderscores)
    }
    
    func isWordGuessed() -> Bool {
        !wordToBeGuessed.contains("_") || wholeWordGuess.lowercased() == word.entry.lowercased()
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Game.self, configurations: config)
        
        let chooseWord: () -> Word? = {
            let fakeList = [
                Word(id: 0, entry: "io", definition: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ", definitionSource: "Treccani", level: .easy)
            ]
            return fakeList.first
        }
        let game = Game()
        @State var gameOver = false
        @State var gameFinished = false
        return GuessingScreen(game: game, isGameFinished: $gameFinished, isGameOver: $gameOver)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create a model container")
    }
}
