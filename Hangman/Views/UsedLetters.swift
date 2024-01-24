//
//  UsedLetters.swift
//  Hangman
//
//  Created by Vittorio Sassu on 21/01/24.
//

import SwiftUI

struct UsedLetters: View {
    @Environment(ModelData.self) var modelData
    
    let columns = [
        GridItem(.fixed(40)),
        GridItem(.fixed(40)),
        GridItem(.fixed(40)),
    ]
    
    var usedLetters: [String]
    
    var body: some View {
        Section("Used letters") {
            LazyVGrid(columns: columns) {
                ForEach(usedLetters, id: \.self) { letter in
                    Text(letter)
                }
            }
        }
    }
}

#Preview {
    UsedLetters(usedLetters: ["a", "b", "c"])
}
