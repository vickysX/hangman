//
//  Word.swift
//  Hangman
//
//  Created by Vittorio Sassu on 19/01/24.
//

import Foundation


struct Word: Codable, Identifiable {
    var id: String
    var entry: String
    var definition: String
}
