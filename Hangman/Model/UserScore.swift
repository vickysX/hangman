//
//  UserScore.swift
//  Hangman
//
//  Created by Vittorio Sassu on 25/01/24.
//

import Foundation
import SwiftData

@Model
class UserScore {
    @Attribute(.unique) var userId: UUID
    
    var username: String
    
    var score: Int
    
    var level: DifficultyLevel
    
    init(username: String, level: DifficultyLevel) {
        userId = UUID()
        self.username = username
        self.score = 0
        self.level = level
    }
}
