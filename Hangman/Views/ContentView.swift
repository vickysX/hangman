//
//  ContentView.swift
//  Hangman
//
//  Created by Vittorio Sassu on 07/01/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(ModelData.self) var modelData
    
    var body: some View {
        NavigationStack {
            VStack {
                // Start composing view
                GuessingSpace(word: modelData.words[0])
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
