//
//  TypeModel.swift
//  PokeAPI
//
//  Created by Shady Elkassas on 01/11/2023.
//

import Foundation


// MARK: - TypeModel
struct TypeModel: Codable {
    let pokemon: [PokemonEntry]
}

struct PokemonEntry: Codable {
    let pokemon: CustomPokemon
    let slot: Int

    private enum CodingKeys: String, CodingKey {
        case pokemon
        case slot
    }
}

struct CustomPokemon: Codable {
    let name: String
    let url: String

    private enum CodingKeys: String, CodingKey {
        case name
        case url
    }
}









