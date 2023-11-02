//
//  GridItemView.swift
//  PokeAPI
//
//  Created by Shady Elkassas on 29/10/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct GridItemView: View {
    
    var pokemon: Pokemon
    let width = UIScreen.main.bounds.width*0.4
    
    //VM
    @EnvironmentObject var viewModel: PokeViewModel
    

    
    var body: some View {
        
        ZStack{
            
            //Rectangular background
            Rectangle()
                .frame(width: width, height: 120)
                .overlay(viewModel.PokemonColors[pokemon.id] ?? .gray) //Color of pokemon
                .cornerRadius(15)
            
             
            //PokeBall art
            Image("PokeBall")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .colorMultiply(Color.white.opacity(0.1))
                        .offset(CGSize(width: 20.0, height: 10.0))
            
            //Data in vertical distribution
            VStack {
                
                //Name and ID HStack
                HStack{
                    
                    Text(pokemon.name.prefix(1).capitalized + pokemon.name.dropFirst())
                    .font(.caption)
                    .frame(alignment: .topLeading)
                    .foregroundColor(.white.opacity(0.9))
                    
                    Spacer()
                    
                    Text(getID(id: pokemon.id))
                        .font(.caption)
                        .frame(alignment: .topLeading)
                        .foregroundColor(Color.white.opacity(0.9))

                    
                }.padding()
                
                Spacer()
                
                //Types and Image HStack
                HStack{
                    
                    VStack{
                       
                        ForEach(pokemon.types){type in
                            TypeView(name: type.type.name)
                        }
                        
                        
                    }.padding(.horizontal, 10)
                    .padding(.bottom)
                    
                   Spacer()
                    
                    
                
                    //Image
                    WebImage(url: URL(string: pokemon.sprites.frontShiny))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                             
                    
                }
            }
                
        } .frame(width: width, height: 120)
        
    }
    


    
    
}



#Preview {
    GridItemView(pokemon: DummyPokemon().dummyPokemon)
}
