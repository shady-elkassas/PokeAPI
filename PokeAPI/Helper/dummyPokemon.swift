//
//  dummyPokemon.swift
//  PokeAPI
//
//  Created by Shady Elkassas on 30/10/2023.
//

import Foundation

struct DummyPokemon{
    

     let dummyPokemon = Pokemon(
        abilities: [
            Ability(ability: Species(name: "overgrow", url: "https://pokeapi.co/api/v2/ability/65/"), isHidden: false, slot: 1),
            Ability(ability: Species(name: "chlorophyll", url: "https://pokeapi.co/api/v2/ability/34/"), isHidden: true, slot: 3)
        ],
        baseExperience: 64,
        forms: [
            Species(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon-form/1/")
        ],
        gameIndices: [
            GameIndex(gameIndex: 1, version: Species(name: "red", url: "https://pokeapi.co/api/v2/version/1/"))
        ],
        height: 7,
        heldItems: [],
        id: 1,
        isDefault: true,
        locationAreaEncounters: "https://pokeapi.co/api/v2/pokemon/1/encounters",
        moves: [
            Move(move: Species(name: "tackle", url: "https://pokeapi.co/api/v2/move/33/"), versionGroupDetails: [])
        ],
        name: "bulbasaur",
        order: 1,
        pastAbilities: [],
        pastTypes: [],
        species: Species(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon-species/1/"),
        sprites: Sprites(
            backDefault: "https://pokeapi.co/media/sprites/pokemon/back/1.png",
            backFemale: nil,
            backShiny: "https://pokeapi.co/media/sprites/pokemon/back/shiny/1.png",
            backShinyFemale: nil,
            frontDefault: "https://pokeapi.co/media/sprites/pokemon/1.png",
            frontFemale: nil,
            frontShiny: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/132.png",
            frontShinyFemale: nil,
            other: nil,
            versions: nil,
            animated: nil
        ),
        stats: [
            Stat(baseStat: 45, effort: 0, stat: Species(name: "hp", url: "https://pokeapi.co/api/v2/stat/1/")),
            Stat(baseStat: 49, effort: 0, stat: Species(name: "attack", url: "https://pokeapi.co/api/v2/stat/2/")),
            Stat(baseStat: 49, effort: 0, stat: Species(name: "defense", url: "https://pokeapi.co/api/v2/stat/3/")),
            Stat(baseStat: 65, effort: 1, stat: Species(name: "special-attack", url: "https://pokeapi.co/api/v2/stat/4/")),
            Stat(baseStat: 65, effort: 0, stat: Species(name: "special-defense", url: "https://pokeapi.co/api/v2/stat/5/")),
            Stat(baseStat: 45, effort: 0, stat: Species(name: "speed", url: "https://pokeapi.co/api/v2/stat/6/"))
        ],
        types: [
            TypeElement(slot: 1, type: Species(name: "grass", url: "https://pokeapi.co/api/v2/type/12/")),
            TypeElement(slot: 2, type: Species(name: "poison", url: "https://pokeapi.co/api/v2/type/4/"))
        ],
        weight: 69,
        color: "Green"
    )

    func returnDummy() -> Pokemon{
        return dummyPokemon
    }
    
}
