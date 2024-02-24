//
//  Definition.swift
//  Hangman
//
//  Created by Vittorio Sassu on 21/01/24.
//

import SwiftUI

struct Definition: View {
    var wordDefinition: String
    var definitionSource: String
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                Image(systemName: "lightbulb.fill")
                    .tint(.yellow)
                Text("\"\(wordDefinition)\"")
                    .font(.caption)
                    .italic()
                    .padding()
                Text(definitionSource)
                    .font(.caption)
            }
        }
        .padding()
    }
}

#Preview {
    Definition(
        wordDefinition: "Ciao, sono una definizione da dizionario",
        definitionSource: "Treccani"
    )
}
