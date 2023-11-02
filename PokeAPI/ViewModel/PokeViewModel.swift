//
//  PokeViewModel.swift
//  PokeAPI
//
//  Created by Shady Elkassas on 29/10/2023.
//

import Foundation
import Combine
import SwiftUI
import CoreData


class PokeViewModel:ObservableObject{
    
    //Published data
    @Published var PokemonList: [Pokemon] = [] //Array of Pokemon objects with all associated data
    @Published var PokemonColors: [Int: Color] = [:]
    
    var PokemonRoot: [PokeRoot] = [] //Array of root pokemons {next page url, results}

    //Pagination of Type Search
    var totalPagesType: Int?
    var currentPageType: Int = 1

    //Pagination of Ability Search
    var totalPagesAbility: Int?
    var currentPageAbility: Int = 1
    
    //Cancellables
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Fetch Pokemon

    //Get the list of pokemon's URL & Name
    func getRoot() {
        
        //First call will result in first page of api response,
        //subsequent calls will fetch next pages
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/") else {
            print("Error in URL or already fetched Pokemon...")
            return
        }

        let requestURL: URL
        if let nextURL = PokemonRoot.last?.next, !nextURL.isEmpty {
            requestURL = URL(string: nextURL)!
        } else {
            requestURL = url
        }

        
        //URLSession
        URLSession.shared.dataTaskPublisher(for: requestURL)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: PokeRoot.self, decoder: JSONDecoder())
            .sink { [weak self] (completion) in
                print("Completion: \(completion)")
                switch completion {
                case .finished:
                    self?.getPokemonDetails() //Begin getting pokemon details
                case .failure(let error):
                    print("Error: \(error)")
                    self?.loadDataFromUserDefaults() //Load cached data if failed to retreive from API
                }
            } receiveValue: { [weak self] root in
                self?.PokemonRoot.append(root) //Append root to Array
            }
            .store(in: &cancellables)
    }

    
    //Retreive the pokemon details of array returned in getRoot() function
    func getPokemonDetails() {
        guard let arrayOfResults = PokemonRoot.last?.results else {
            print("Error in root array...")
            return
        }
        
        let dispatchGroup = DispatchGroup() // Create a DispatchGroup

        var fetchedPokemonItems: [Pokemon] = []

        for result in arrayOfResults {
            guard let url = URL(string: result.url) else {
                print("Error in URL for result \(result.name)")
                continue
            }

            dispatchGroup.enter() // Enter the DispatchGroup before making an API call

            URLSession.shared.dataTaskPublisher(for: url)
                .subscribe(on: DispatchQueue.global())
                .receive(on: DispatchQueue.main)
                .tryMap { (data, response) -> Data in
                    guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                        throw URLError(.badServerResponse)
                    }
                    return data
                }
                .decode(type: Pokemon.self, decoder: JSONDecoder())
                .flatMap { pokemon in
                    return self.fetchPokemonColor(for: pokemon)
                        .map { _ in
                            return pokemon
                        }
                        .replaceError(with: pokemon)
                }
                .sink { (completion) in
                    dispatchGroup.leave() // Leave the DispatchGroup when the API call is completed

                    if case .finished = completion {
                        print("Completion: \(completion)")
                    }
                } receiveValue: {  pokemon in
                    fetchedPokemonItems.append(pokemon)
                   
                }
                .store(in: &cancellables)
        }

        dispatchGroup.notify(queue: .main) {
            // All API calls have completed
            self.PokemonList.append(contentsOf: fetchedPokemonItems)
            self.PokemonList.sort { $0.id < $1.id } // Sort the fetched Pokémon items by ID
        }
    }


    //Fetch Pokemon background color
    func fetchPokemonColor(for pokemon: Pokemon) -> AnyPublisher<Void, Never> {
        guard let url = URL(string: pokemon.species.url) else {
            print("Error in URL for species information")
            return Just(()).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard
                    let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 300
                else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: PokemonSpecies.self, decoder: JSONDecoder())
            .map { species in
                let colorName = species.color.name
               
                
                // Set the color property of the corresponding Pokemon
                self.PokemonColors[pokemon.id] = self.getColorFromName(colorName: colorName)
                self.saveDataToUserDefaults()
                
            }
            .catch { _ in Empty<Void, Never>() }
            .eraseToAnyPublisher()
    }

    
    //Helper function to retreive corresponding Color
    func getColorFromName(colorName: String?) -> Color {
        if let name = colorName {
            print("Received color name: \(name)")
            
            switch name.lowercased() {
                
                    case "red":
                        return Color.red
                    case "blue":
                        return Color.blue
                    case "yellow":
                        return Color.yellow
                    case "green":
                        return Color.green
                    case "brown":
                        return Color(red: 0.6, green: 0.4, blue: 0.2)
                    case "purple":
                        return Color.purple
                    case "pink":
                        return Color.pink
                    case "gray":
                        return Color.gray
                    case "white":
                        return Color.white
                    case "black":
                        return Color.black
                    case "orange":
                        return Color.orange
                    case "cyan":
                        return Color.blue // Cyan is not directly available, so using blue as a substitute.
                    case "dark":
                        return Color.black.opacity(0.6) // A darker shade of black.
                    default:
                        return Color.gray // Default to gray for unknown colors.
                
            }
        } else {
            print("Color name is nil or empty.")
        }
        
        return Color.gray
    }
    
    
    // MARK: - Caching

    //Save PokemonList to UserDefaults
    func saveDataToUserDefaults() {
         
          let encoder = JSONEncoder()
          if let encodedData = try? encoder.encode(PokemonList) {
              UserDefaults.standard.set(encodedData, forKey: "PokemonList")
          }
         
      }

    // Load PokemonList from UserDefaults
    func loadDataFromUserDefaults() {
        
        let decoder = JSONDecoder()
        if let savedData = UserDefaults.standard.data(forKey: "PokemonList") {
            if let loadedData = try? decoder.decode([Pokemon].self, from: savedData) {
                PokemonList = loadedData
            }
        }
        
    }

  
    // MARK: - Filter

    //Filter pokemon by name
    func fetchPokemonInfoByName(name: String) {
        
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(name.lowercased())")!
      
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .tryMap { data, _ in
                try JSONDecoder().decode(Pokemon.self, from: data)
            }
            .flatMap { pokemon in
                return self.fetchPokemonColor(for: pokemon)
                    .map { _ in
                        return pokemon
                    }
                    .replaceError(with: pokemon)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                   case .failure(let error):
                    self.fetchPokemonByType(typeName: name)
                       print("Error: \(error)")
                   case .finished:
                       // Handle successful completion here
                    print("PokeList: \(self.PokemonList.count)")

                       print("API request completed successfully")
                   }
            }, receiveValue: { pokemon in
                // Handle the received Pokemon data here
                self.PokemonList.append(pokemon)
            })
            .store(in: &cancellables)
    }
    
    
    //Filter pokemon by type
    func fetchPokemonByType(typeName: String) {
        let limit = 20 // Set the limit to the number of items you want to fetch per page
        let offset = (currentPageType - 1) * limit // Calculate the offset for the current page

        let url = URL(string: "https://pokeapi.co/api/v2/type/\(typeName.lowercased())?limit=\(limit)&offset=\(offset)")!

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)  // Extract the data from the response
            .decode(type: TypeModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.fetchPokemonByAbility(abilityName: typeName)
                    print("Error: \(error)")
                case .finished:
                    print("API request completed successfully for page \(self.currentPageType)")
                    if let total = self.totalPagesType, self.currentPageType < total {
                        // Fetch the next page if available
                        self.currentPageType += 1
                       
                    }
                }
            }, receiveValue: { typeModel in
                if self.totalPagesType == nil {
                    // Calculate the total pages based on the total number of Pokemon types
                    self.totalPagesType = (typeModel.pokemon.count + limit - 1) / limit
                }
                let pokemons = typeModel.pokemon
                print("Number of pokemons is: \(typeModel.pokemon.count)")
                for pokemon in pokemons {
                    let name = pokemon.pokemon.name
                    self.fetchPokemonInfoByName(name: name)
                }
            })
            .store(in: &cancellables)
    }


    //Filter pokemon by ability
    func fetchPokemonByAbility(abilityName: String) {
        let limit = 20 // Set the limit to the number of items you want to fetch per page
        let offset = (currentPageAbility - 1) * limit // Calculate the offset for the current page

        let url = URL(string: "https://pokeapi.co/api/v2/ability/\(abilityName.lowercased())?limit=\(limit)&offset=\(offset)")!

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)  // Extract the data from the response
            .decode(type: TypeModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    
                    print("Error: \(error)")
                case .finished:
                    print("API request completed successfully for page \(self.currentPageAbility)")
                    if let total = self.totalPagesAbility, self.currentPageAbility < total {
                        // Fetch the next page if available
                        self.currentPageAbility += 1
                       
                    }
                }
            }, receiveValue: { typeModel in
                if self.totalPagesAbility == nil {
                    // Calculate the total pages based on the total number of Pokemon types
                    self.totalPagesAbility = (typeModel.pokemon.count + limit - 1) / limit
                }
                let pokemons = typeModel.pokemon
                for pokemon in pokemons {
                    let name = pokemon.pokemon.name
                    self.fetchPokemonInfoByName(name: name)
                }
            })
            .store(in: &cancellables)
    }

}
