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
    
    @Query(sort: \UserScore.score) var userScores: [UserScore]
    
    var body: some View {
        NavigationStack {
            VStack {
                // Start composing view
                GuessingScreen(word: modelData.words[0], userScore: userScores[0])
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
