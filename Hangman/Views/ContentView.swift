//
//  ContentView.swift
//  Hangman
//
//  Created by Vittorio Sassu on 07/01/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(ModelData.self) var modelData
    @Environment(\.modelContext) var context
    
    static var fetchDescriptor: FetchDescriptor<Game> {
        var descriptor = FetchDescriptor<Game>(sortBy: [SortDescriptor(\Game.score, order: .reverse)])
        descriptor.fetchLimit = 8
        return descriptor
    }
    
    var scoreStyledText: AttributedString {
        do {
            let result = try AttributedString(markdown: "**Score**")
            return result
        } catch {
           fatalError("Couldn't parse the text")
        }
    }
    
    @Query(fetchDescriptor) var pastGames: [Game]
    
    var newGame = Game()
    
    var body: some View {
        NavigationStack {
            //VStack {
                List {
                    NavigationLink(
                        destination: GuessingScreen(
                            game: Game()
                        )) {
                        Label("Start new game", systemImage: "dice")
                            .foregroundColor(.accentColor)
                    }
                    if pastGames.isEmpty {
                        Text("It seems you have never played before! What are you waiting for?")
                            .multilineTextAlignment(.center)
                            .font(.largeTitle)
                            .padding()
                    } else {
                        Section("Your best games") {
                            ForEach(pastGames) { game in
                                Text("\(scoreStyledText): \(game.score)\n\(game.date.formatted(date: .abbreviated, time: .shortened))")
                            }
                        }
                    }
                }
            //}
            .navigationTitle("Hangman")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    ContentView()
}
