//
//  UsedLetters.swift
//  Hangman
//
//  Created by Vittorio Sassu on 21/01/24.
//

import SwiftUI

struct UsedLetters: View {
    
    let columns = [
        GridItem(.adaptive(minimum: 80))
    ]
    
    var usedLetters: [String]
    
    var body: some View {
        Section("Used letters") {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(usedLetters, id: \.self) { letter in
                        Text(letter)
                    }
                    .padding(.all, 8)
                }
                .animation(.default, value: usedLetters)
            }
        }
    }
}

#Preview {
    Form {
        UsedLetters(usedLetters: ["a", "b", "c", "d", "e", "f"])
    }
}
