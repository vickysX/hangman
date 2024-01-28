//
//  UserScore.swift
//  Hangman
//
//  Created by Vittorio Sassu on 25/01/24.
//

import Foundation
import SwiftData

@Model
final class Game {
    @Attribute(.unique) var gameId: UUID
    
    var score: Int
    
    var level: DifficultyLevel
    
    var date: Date
    
    init(score: Int = 10, level: DifficultyLevel = .easy, date: Date = .now) {
        gameId = UUID()
        self.score = score
        self.level = level
        self.date = date
    }
}
