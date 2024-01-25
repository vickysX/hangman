//
//  DifficultyLevel.swift
//  Hangman
//
//  Created by Vittorio Sassu on 25/01/24.
//

import Foundation

enum DifficultyLevel: String, Codable, CaseIterable {
    case easy = "easy"
    case medium = "medium"
    case difficult = "difficult"
}
