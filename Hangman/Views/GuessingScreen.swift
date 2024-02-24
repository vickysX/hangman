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
    @Environment(\.dismiss) private var dismiss
    
    @FocusState private var isWholeWordFieldFocused: Bool
    
    @State private var showingDefinition = false
    @State private var usedLetters = [String]()
    
    @State private var letterSelection = "a"
    
    @State private var wholeWordGuess = ""
    
    @State private var showingInvalidLetterAlert = false
    @State private var invalidLetterMessage = ""
    
    @State private var showingWrongWholeWordAlert = false
    
    @State private var showingGuessedWordAlert = false
    
    @State private var showGameFinishedAlert = false
    @State private var showGameOverAlert = false
    
    @State private var wordOptional: Word? = nil
    
    @State private var wordInUnderscores = [String]()
    
    @Bindable var game: Game
    
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
        switch game.level {
        case .easy:
            return 1
        case .medium, .difficult:
            return 2
        }
    }
    
    var wrongGuessesInScorePoints: Int {
        usedLetters.count * scoreIncrementBasedOnLevel
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Form {
                Section {
                    HStack {
                        Text(wordToBeGuessed)
                            .font(.largeTitle)
                            .padding()
                            .frame(alignment: .center)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("Error points: \(wrongGuessesInScorePoints)")
                            Text("Score: \(game.score)")
                            Text("Level: \(game.level.rawValue)")
                        }
                        .font(.caption)
                        .multilineTextAlignment(.trailing)
                    }
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
                        .keyboardType(.alphabet)
                        .focused($isWholeWordFieldFocused)
                        .onSubmit {
                            acceptWholeWord()
                            isWholeWordFieldFocused = false
                        }
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
            .navigationTitle("Hangman")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
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
        .alert("Endgame", isPresented: $showGameFinishedAlert) {
            Button("OK", role: .cancel) {
                context.insert(game)
                dismiss()
            }
            Button("Exit", role: .destructive) {
                context.insert(game)
                exit(0)
            }
        } message: {
            Text("Congratulations, you won!")
        }
        .alert("Game Over", isPresented: $showGameOverAlert) {
            Button("OK", role: .cancel) {
                context.insert(game)
                dismiss()
            }
            Button("Exit", role: .destructive) {
                context.insert(game)
                exit(0)
            }
        } message: {
            Text("LOOOSEEERRR")
        }
        .toolbar {
            Button("Guess") {
                guard wholeWordGuess.isEmpty else {
                    acceptWholeWord()
                    isWholeWordFieldFocused = false
                    return
                }
                accept(letter: letterSelection)
            }
        }
        
    }
    
    func startGuessing() {
        if usedLetters.isNotEmpty {
            withAnimation {
                usedLetters = []
            }
        }
        
        guard !game.isFinished else {
            showGameFinishedAlert = true
            return
        }
        
        guard !game.isOver else {
            showGameOverAlert = true
            return
        }
        
        if wrongGuessesInScorePoints <= 6 && game.score > 10 {
            game.goToNextLevel()
        }
        
        wordOptional = game.chooseWordToGuess(from: modelData.words)
        
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
        
        guard !game.isOver else {
            showGameOverAlert = true
            return
        }
        
        withAnimation {
            usedLetters = []
            wholeWordGuess = ""
        }
        
        game.score += word.entry.count + scoreIncrementBasedOnLevel
        game.numWords += 1
        showingGuessedWordAlert = true
    }
    
    func accept(letter: String) {
        
        guard usedLetters.doesNotContain(letter) else {
            showingInvalidLetterAlert = true
            invalidLetterMessage = "You already tried this letter."
            return
        }
        
        guard letter.isLetter else {
            showingInvalidLetterAlert = true
            invalidLetterMessage = "Invalid character. You can only insert a letter."
            return
        }
        
        guard doesWordContain(input: letter) else {
            withAnimation {
                usedLetters.append(letter)
                game.score -= scoreIncrementBasedOnLevel
            }
            guard !game.isOver else {
                showGameOverAlert = true
                return
            }
            return
        }
        
        insert(input: letter)
        game.score += scoreIncrementBasedOnLevel
        
        guard isWordGuessed() else {
            return
        }
        
        showingGuessedWordAlert = true
        game.numWords += 1
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
        
        let chooseWord: () -> Word? = {
            let fakeList = [
                Word(id: 0, entry: "io", definition: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ", definitionSource: "Treccani", level: .easy)
            ]
            return fakeList.first
        }
        let game = Game()
        @State var gameOver = false
        @State var gameFinished = false
        return GuessingScreen(game: game)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create a model container")
    }
}
