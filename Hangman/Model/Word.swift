//
//  Word.swift
//  Hangman
//
//  Created by Vittorio Sassu on 19/01/24.
//

import Foundation

// Codable protocol combines both Encodable and Decodable protocols
// Types conforming to Codable are also conforming to Encodable and Decodable
struct Word: Codable, Hashable, Identifiable {
    var id: Int
    var entry: String
    var definition: String
    var definitionSource: String
    var level: DifficultyLevel
    
    enum DifficultyLevel: String, Codable {
        case easy = "easy"
        case medium = "medium"
        case difficult = "difficult"
    }
}


