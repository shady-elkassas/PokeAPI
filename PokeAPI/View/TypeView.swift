//
//  TypeView.swift
//  PokeAPI
//
//  Created by Shady Elkassas on 30/10/2023.
//

import SwiftUI

struct TypeView: View {
    
    var name:String
    var color:Color?
    var customWidth: CGFloat?
    var customFont: String?
    
    let width = UIScreen.main.bounds.width
    
    var body: some View {
        
        
       
        
        ZStack {
        Rectangle()
        .frame(width: customWidth ?? width * 0.14, height: 25) // Adjust the height as needed
        .cornerRadius(50)
        .foregroundColor(color?.opacity(0.4) ?? Color.gray.opacity(0.4)) // Background color
                
            if customFont != nil && color != nil{
                Text(name.prefix(1).capitalized + name.dropFirst())
                    .font(.custom(customFont ?? "ClabPersonalUse-Regular", size: 16))
                    .foregroundColor(.white)
            }else{
                Text(name.prefix(1).capitalized + name.dropFirst())
                .foregroundColor(Color.white)
                .font(.caption)
            }
       
        
        
            
    }
        
        
    }
}

#Preview {
    TypeView(name: "Fire")
}
