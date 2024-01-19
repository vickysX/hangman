//
//  ModelData.swift
//  Hangman
//
//  Created by Vittorio Sassu on 19/01/24.
//

import Foundation


@Observable
class ModelData {
    let words: [Word] = load(file: "words")
}

func load<T: Decodable>(file filename: String) -> T {
    // Set byte buffer
    let data: Data
    
    // Check if file exists
    // If it does create a file constant of type URL
    // otherwise crash the app
    guard let file = Bundle.main.url(forResource: filename, withExtension: "json") else {
        fatalError("Couldn't file \(filename) in main bundle")
    }
    
    // transform file data into a buffer of bytes
    do {
       data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't file \(filename) in main bundle\n\(error)")
    }
    
    // decode JSON data
    // into an object conform to Decodable
    // and return it
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("")
    }
}
