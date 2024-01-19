//
//  Word.swift
//  Hangman
//
//  Created by Vittorio Sassu on 19/01/24.
//

import Foundation


struct Word: Codable, Hashable, Identifiable {
    var id: Int
    var entry: String
    var definition: String
    var level: DifficultyLevel
    
    enum DifficultyLevel: String, Codable {
        case Easy = "easy"
        case Medium = "medium"
        case Difficult = "difficult"
    }
}


