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
        self.numWords >= 3
    }
    
    var isOver: Bool {
        self.score < 0
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

extension Game {
    func chooseWordToGuess(from words: [Word]) -> Word? {
        print(self.level)
        let wordsAtCurrentLevel = words
            .filter {word in
            (word.level == self.level)
        }
        print(wordsAtCurrentLevel)
        return self.isFinished || self.isOver ?
            nil :
            wordsAtCurrentLevel.randomElement()
    }
    
    func goToNextLevel() {
        switch self.level {
        case .easy:
            self.level = .medium
        case .medium:
            self.level = .difficult
        case .difficult:
            self.level = .easy
        }
    }
}
