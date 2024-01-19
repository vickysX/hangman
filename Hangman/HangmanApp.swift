//
//  HangmanApp.swift
//  Hangman
//
//  Created by Vittorio Sassu on 07/01/24.
//

import SwiftUI

@main
struct HangmanApp: App {
    @State private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(modelData)
        }
    }
}
