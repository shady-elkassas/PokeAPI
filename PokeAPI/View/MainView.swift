//
//  ContentView.swift
//  PokeAPI
//
//  Created by Shady Elkassas on 29/10/2023.
//

import SwiftUI


struct MainView: View {
    
    //TextField input text
    @State var searchText: String = ""
    
    //VM
    @EnvironmentObject var viewModel: PokeViewModel
    
    //ColorScheme
    @Environment(\.colorScheme) var colorScheme
    
    //For network status
    @ObservedObject var networkMonitor = NetworkMonitor()
    
    //Flag to load more data
    @State var reachedEndOfList = false
    
    //40% of screen width
    let width = UIScreen.main.bounds.width*0.4
    
    //For the list of pokemons
    let columns = 2
    let spacing: CGFloat = 16
    
    
    var body: some View {
               
        
        NavigationView{
            
            VStack{
                
                VStack(alignment: .leading) {
                    
                    //Title
                    HStack(spacing: 10 ) {
                        Text("Pokédex")
                            .font(.custom("ClabPersonalUse-Bold", size: 36))
                            .padding(.horizontal)
                            .padding(.top, 8)
                        
                        //No signal sign
                        if(!networkMonitor.isConnected){
                            
                            Image(systemName: "wifi.slash")
                                .resizable()
                                .foregroundColor(.gray)
                                .frame(width: 30, height: 30)
                            
                            
                        }
                        
                        
                    }
                    
                    //Body text
                    Text("Use advanced search to find Pokémon by name, type, ability, and more!")
                        .font(.custom("ClabPersonalUse-Regular", size: 22))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                        .padding(.top, 2)
                    
                    
                }
                
                //Search field and button
                HStack {
                    
                    TextField("", text: $searchText, prompt: Text("Search a Pokémon").foregroundColor(.black.opacity(0.5)))
                        .padding(11)
                        .padding(.horizontal, 20)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 0.2)
                        )
                        .padding(.leading, 8)
                        .overlay(
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.black)
                                    .padding(.leading, 15)
                                Spacer()
                            }
                        )
                        .font(.system(size: 15))
                    
                    
                    
                    
                    
                    Button(action: {
                        
                        // Perform search action
                        viewModel.PokemonList.removeAll()
                        viewModel.fetchPokemonInfoByName(name: searchText)
                        
                    }) {
                        Image("filter").resizable().frame(width: 20, height: 20)
                    }
                    .frame(width: 45, height: 45)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(15) // Make it a circle
                }
                .padding(.horizontal, 12)
                
                
                //List of pokemons
                ScrollView {
                    
                    VStack(spacing: spacing) {
                        ForEach(0..<viewModel.PokemonList.count, id: \.self) { index in
                            if index % columns == 0 {
                                HStack(spacing: spacing) {
                                    ForEach(index..<index+columns, id: \.self) { innerIndex in
                                        if innerIndex < viewModel.PokemonList.count {
                                            NavigationLink(destination: DetailView(pokemon: viewModel.PokemonList[innerIndex])) {
                                                
                                                GridItemView(pokemon: viewModel.PokemonList[innerIndex])
                                                    .id(viewModel.PokemonList[innerIndex].id)
                                                    .onAppear {
                                                        print("Number in viewModel: \(viewModel.PokemonList.count)")
                                                    }
                                            
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        }
                        
                    }
                    
                    
                    //if the textfield is empty load more -not filtered- pokemons
                    if searchText.isEmpty{
                        Button {
                           
                            reachedEndOfList = true
                            
                        } label: {
                            
                            Text("Load More")
                                .font(.custom("ClabPersonalUse-Regular", size: 18))
                                .frame(width: width, height: 42, alignment: .center)
                                .foregroundColor(colorScheme == .light ? .black:.white)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(colorScheme == .light ? .black:.white, lineWidth: 1)
                                }.padding()
                            
                            
                        }
                    }else{ //Load filtered pokemons
                        Button {
                            viewModel.fetchPokemonByType(typeName: searchText)
                        } label: {
                            
                            Text("Load More")
                                .font(.custom("ClabPersonalUse-Regular", size: 18))
                                .frame(width: width, height: 42, alignment: .center)
                                .foregroundColor(.black)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(colorScheme == .light ? .black:.white, lineWidth: 1)
                                }.padding()
                            
                        }
                        
                    }
                    
                }
                
            }
            //Load first list of pokemons
            .onAppear {
                if searchText.isEmpty{
                    viewModel.getRoot()
                }
            }
            //Load subsequent lists
            .onChange(of: reachedEndOfList) { value in
                if value == true{
                    viewModel.getRoot()
                    reachedEndOfList = false
                }
            }
            
        }
        .accentColor(.black.opacity(0.5))
        .navigationViewStyle(StackNavigationViewStyle())
    
    }
    
}

#Preview {
    MainView()
}



