//
//  UserScore.swift
//  Hangman
//
//  Created by Vittorio Sassu on 25/01/24.
//

import Foundation
import SwiftData

@Model
final class UserScore {
    @Attribute(.unique) var userId: UUID
    
    var username: String
    
    var score: Int
    
    var level: DifficultyLevel
    
    var date: Date
    
    init(username: String, score: Int = 10, level: DifficultyLevel, date: Date = .now) {
        userId = UUID()
        self.username = username
        self.score = score
        self.level = level
        self.date = date
    }
}
