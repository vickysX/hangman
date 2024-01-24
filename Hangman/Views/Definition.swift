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
        VStack(alignment: .leading) {
            Text(wordDefinition)
                .font(.caption)
                .italic()
            Spacer()
            Text(definitionSource)
                .font(.footnote)
        }
        
    }
}

#Preview {
    Definition(
        wordDefinition: "Ciao, sono una definizione da dizionario",
        definitionSource: "Treccani"
    )
}
