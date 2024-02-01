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
    
    var body: some View {
        NavigationStack {
            Section {
                List {
                    NavigationLink(destination: GuessingScreen(word: modelData.words[0], game: Game())) {
                        Label("Start new game", image: "dice")
                            .foregroundColor(.accentColor)
                    }
                    if pastGames.isEmpty {
                        Text("It seems you have never played before!")
                            .font(.largeTitle)
                    } else {
                        ForEach(pastGames) { game in
                            Text("Score: \(game.score)")
                        }
                    }
                }
            }
            .navigationTitle("Hangman")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
