//
//  ContentView.swift
//  Hangman
//
//  Created by Vittorio Sassu on 07/01/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(ModelData.self) var modelData
    @Environment(\.modelContext) var context
    
    static var fetchDescriptor: FetchDescriptor<Game> {
        var descriptor = FetchDescriptor<Game>(sortBy: [SortDescriptor(\Game.score, order: .reverse)])
        descriptor.fetchLimit = 5
        return descriptor
    }
    
    @Query(fetchDescriptor) var pastGames: [Game]
    
    var newGame = Game()
    
    var body: some View {
        NavigationStack {
            //VStack {
                List {
                    NavigationLink(destination: GuessingScreen(chooseWord: chooseWordToGuess, game: Game())) {
                        Label("Start new game", systemImage: "dice")
                            .foregroundColor(.accentColor)
                    }
                    if pastGames.isEmpty {
                        Text("It seems you have never played before! What are you waiting for?")
                            .multilineTextAlignment(.center)
                            .font(.largeTitle)
                            .padding()
                    } else {
                        Section("Your best games") {
                            ForEach(pastGames) { game in
                                Text("Score: \(game.score)\n\(game.date.formatted(date: .abbreviated, time: .shortened))")
                            }
                        }
                    }
                }
            //}
            .navigationTitle("Hangman")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    func chooseWordToGuess() -> Word? {
        let wordsAtCurrentLevel = modelData.words
            .filter {word in
            word.level == newGame.level
        }
        return newGame.isFinished ?
            nil :
            wordsAtCurrentLevel.randomElement()
    }
}

#Preview {
    ContentView()
}
