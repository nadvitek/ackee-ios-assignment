//
//  CharacterListItemView.swift
//  RickAndMorty
//
//  Created by Vít Nademlejnský on 09.09.2023.
//

import SwiftUI

struct CharacterListItemView: View {
    @EnvironmentObject var menuViewModel: MenuViewModel
    
    let char: Character
    
    var body: some View {
        Rectangle()
            .cornerRadius(menuViewModel.isFocused ? 0 : 15)
            .foregroundColor(menuViewModel.isFocused ? .bg : .item)
            .frame(maxWidth: .infinity)
            .frame(height: 65)
            .overlay(content: {
                HStack {
                    AsyncImage(url: URL(string: char.image), scale: 6)
                        .frame(width: 55, height: 55)
                        .cornerRadius(20)
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(char.name)
                                .fontWeight(.bold)
                                .foregroundColor(.baw)
                            if menuViewModel.isCharacterFavorite(char) && !menuViewModel.isFocused {
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 15)
                                    .foregroundColor(.selected)
                            }
                        }
                        Text(char.status)
                            .foregroundColor(.gray)
                    }.padding(5)
                    Spacer()
                    if !menuViewModel.isFocused {
                        Image(systemName: "chevron.forward")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 10)
                            .foregroundColor(.baw)
                            .padding(5)
                    }
                    
                }
                .padding(7)
            }).padding(.horizontal)
            .shadow(radius: menuViewModel.isFocused ? 0 : 5)
    }
}

struct CharacterListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.bg
            CharacterListItemView(char: Character(id: 1, name: "Aa", status: "BB", species: "CC", type: "DD", gender: "EE", origin: LocationOrOrigin(name: ""), location: LocationOrOrigin(name: ""), image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"))
                .environmentObject(MenuViewModel(apiManager: DefaultApiManager(urlStringCreator: urlFunc)))
        }
    }
}
