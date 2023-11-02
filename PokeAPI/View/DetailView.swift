//
//  DetailView.swift
//  PokeAPI
//
//  Created by Shady Elkassas on 29/10/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailView: View {
  
    //Injected data
    var pokemon: Pokemon
    
    //Screen Dimensions
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    //Custom width = 30% of screen width.
    let customWidth = UIScreen.main.bounds.width*0.3
    
    //VM
    @EnvironmentObject var viewModel: PokeViewModel
    
    
    var body: some View {
        
        
        ScrollView{
            
            VStack {
                                        
                ZStack {
                           Rectangle()
                                .frame(width: width, height: 0.3 * height)
                                .foregroundColor(.clear)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            viewModel.PokemonColors[pokemon.id] ?? .clear, // Start color
                                            .clear, // End color (clear for gradient effect)
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )

                                .offset(y: -0.15 * UIScreen.main.bounds.height)
                            
                            //Pokemon image
                            WebImage(url: URL(string: pokemon.sprites.frontShiny))
                                .resizable()
                                .frame(width: width*0.4, height: width*0.4)
                                .foregroundColor(.yellow)
                }
              
                
                //Pokemon Name
                Text(pokemon.name.prefix(1).capitalized + pokemon.name.dropFirst())
                    .font(.custom("ClabPersonalUse-BoldItalic", size: 36))
                    .foregroundColor(viewModel.PokemonColors[pokemon.id]?.opacity(0.55) ?? .gray)
                
                
                //Abilities
                VStack{
                    
                   Text("Abilities") 
                    .font(.custom("ClabPersonalUse-Bold", size: 24))
                    .foregroundColor(viewModel.PokemonColors[pokemon.id]?.opacity(0.55) ?? .gray)
                    
                    ScrollView {
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: UIScreen.main.bounds.width * 0.3), spacing: 10)], spacing: 10) {
                                    ForEach(pokemon.abilities) { ability in
                                        TypeView(name: ability.ability.name, color: viewModel.PokemonColors[pokemon.id], customWidth: 0.3*width, customFont: "ClabPersonalUse-Regular")
                                    }
                                }
                                .padding(10)
                            }
                    
                }
                .frame(width: width*0.8)
                .padding()
                .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(viewModel.PokemonColors[pokemon.id] ?? .gray, lineWidth: 0.5)
                )
                .shadow(radius: 1)
                  
                
                //Types
                VStack{
                    
                   Text("Types")
                    .font(.custom("ClabPersonalUse-Bold", size: 24))
                    .foregroundColor(viewModel.PokemonColors[pokemon.id]?.opacity(0.55) ?? .gray)
                    
                    
                    ScrollView {
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: UIScreen.main.bounds.width * 0.3), spacing: 10)], spacing: 10) {
                                    
                                    
                                    
                                    if pokemon.types.count == 1 {
                                               // Center the TypeView when there's only one type
                                               TypeView(name: pokemon.types[0].type.name, color: viewModel.PokemonColors[pokemon.id], customWidth:customWidth, customFont: "ClabPersonalUse-Regular")
                                                   .frame(maxWidth: width, alignment: .center)
                                           } else {
                                               // Display multiple TypeViews in the grid
                                               ForEach(pokemon.types) { type in
                                                   TypeView(name: type.type.name, color: viewModel.PokemonColors[pokemon.id], customWidth: 0.28 * width, customFont: "ClabPersonalUse-Regular")
                                               }
                                           }
                                    
                                    
                                    
                                    
                                    
                                }
                                .padding(10)
                            }
                    
                }
                .frame(width: width*0.8)
                .padding()
                .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(viewModel.PokemonColors[pokemon.id] ?? .gray, lineWidth: 0.5)
                )
                .shadow(radius: 1)
                    
                
                //Moves
                VStack{
                    
                   Text("Moves")
                    .font(.custom("ClabPersonalUse-Bold", size: 24))
                    .foregroundColor(viewModel.PokemonColors[pokemon.id]?.opacity(0.55) ?? .gray)
                    
                    
                    ScrollView {
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: UIScreen.main.bounds.width * 0.32), spacing: 10)], spacing: 10) {
                                    ForEach(pokemon.moves) { move in
                                        TypeView(name: move.move.name, color: viewModel.PokemonColors[pokemon.id], customWidth: customWidth, customFont: "ClabPersonalUse-Regular")
                                    }
                                }
                                .padding(10)
                            }
                    
                }
                .frame(width: width*0.8)
                .padding()
                .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(viewModel.PokemonColors[pokemon.id] ?? .gray, lineWidth: 0.5)
                )
                .shadow(radius: 1)

                
                }
            
            
        }
        
    }
    
    
}

#Preview {
    DetailView(pokemon: DummyPokemon().returnDummy())
}
