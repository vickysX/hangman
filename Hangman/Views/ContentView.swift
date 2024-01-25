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
    
    @Query var userScore: UserScore
    
    // TODO: Move state for word guessed here
    
    var body: some View {
        @Bindable var score = userScore
        NavigationStack {
            VStack {
                // Start composing view
                GuessingSpace(word: modelData.words[0])
                    .navigationTitle("Hangman")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
