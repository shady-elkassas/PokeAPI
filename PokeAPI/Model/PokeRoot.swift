//
//  RootModel.swift
//  PokeAPI
//
//  Created by Shady Elkassas on 02/11/2023.
//

import Foundation

// MARK: - Root
struct PokeRoot: Codable, Sequence {
    
    let count: Int
    let next: String
    let previous: String?
    let results: [Result]
    
    // Implement the `makeIterator` method required by `Sequence`
      func makeIterator() -> IndexingIterator<[Result]> {
          return results.makeIterator()
      }
}

// MARK: - Result
struct Result: Codable {
    let name: String
    let url: String
}
