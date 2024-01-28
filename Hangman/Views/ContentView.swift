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
    
    @Query(sort: \Game.score) var pastGames: [Game]
    
    var body: some View {
        NavigationStack {
            VStack {
                // Start composing view
                GuessingScreen(word: modelData.words[0], game: Game())
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
