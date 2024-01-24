//
//  String.swift
//  Hangman
//
//  Created by Vittorio Sassu on 22/01/24.
//

import Foundation


extension String {
    var isDigit: Bool {
        self.contains(Regex(/[0-9]/))
    }
    
    var isNotDigit: Bool {
        !self.isDigit
    }
    
    var isLetterOrHyphen: Bool {
        self.contains(Regex(/[a-zA-Z-]/))
    }
    
}
