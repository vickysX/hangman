//
//  Array.swift
//  Hangman
//
//  Created by Vittorio Sassu on 22/01/24.
//

import Foundation


extension Array {
    func doesNotContain(_ element: Element) -> Bool where Element: Equatable {
        !self.contains(element)
    }
}
