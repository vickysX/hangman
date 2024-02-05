//
//  UserScore.swift
//  Hangman
//
//  Created by Vittorio Sassu on 25/01/24.
//

import Foundation
import SwiftData

@Model
final class Game: Identifiable, Hashable {
    @Attribute(.unique) var gameId: UUID
    
    var score: Int
    
    var level: DifficultyLevel
    
    var date: Date
    
    var numWords: Int
    
    var isFinished: Bool {
        numWords >= 3
    }
    
    var isOver: Bool {
        score < 0
    }
    
    init(
        score: Int = 10,
        level: DifficultyLevel = .easy,
        date: Date = .now,
        numWords: Int = 0
    ) {
        gameId = UUID()
        self.score = score
        self.level = level
        self.date = date
        self.numWords = numWords
    }
}
