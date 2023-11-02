//
//  PokeAPIApp.swift
//  PokeAPI
//
//  Created by Shady Elkassas on 29/10/2023.
//

import SwiftUI

@main
struct PokeAPIApp: App {
    
    @StateObject var viewModel: PokeViewModel = PokeViewModel()
    
    var body: some Scene {
       
     
        
        WindowGroup {
            MainView()
                .environmentObject(viewModel)
        }
    }
}
