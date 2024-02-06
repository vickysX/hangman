//
//  HangmanApp.swift
//  Hangman
//
//  Created by Vittorio Sassu on 07/01/24.
//

import SwiftUI
import SwiftData

@main
struct HangmanApp: App {
    @State private var modelData = ModelData()
    
    let modelContainer: ModelContainer
        
    init() {
        do {
            modelContainer = try ModelContainer(for: Game.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(modelData)
        .modelContainer(modelContainer)
    }
}
