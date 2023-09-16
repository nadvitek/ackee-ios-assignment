//
//  MenuScrollView.swift
//  RickAndMorty
//
//  Created by Vít Nademlejnský on 12.09.2023.
//

import SwiftUI

struct MenuScrollView: View {
    @EnvironmentObject var menuViewModel: MenuViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                if (menuViewModel.menuSelected == .Rick) {
                    SearchBarView()
                        .environmentObject(menuViewModel)
                }
                if (menuViewModel.fetchingIsRunning
                    && menuViewModel.isFocused
                    && !menuViewModel.fetchPage) {
                    ProgressView()
                        .frame(maxHeight: .infinity, alignment: .center)
                } else if (menuViewModel.isFocused &&
                           !menuViewModel.searchText.isEmpty &&
                           menuViewModel.characters.isEmpty) {
                    Text("No such character found.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(menuViewModel.characters, id: \.id) { char in
                        NavigationLink {
                            CharacterDetailView(char: char)
                                .environmentObject(menuViewModel)
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            CharacterListItemView(char: char)
                                .environmentObject(menuViewModel)
                                .padding(.vertical, menuViewModel.isFocused ? 0 : 5)
                        }
                        
                    }
                    
                    PaginationMechanism()
                        .environmentObject(menuViewModel)
                }
            }
        }
    }
}

struct MenuScrollView_Previews: PreviewProvider {
    static var previews: some View {
        MenuScrollView()
            .environmentObject(MenuViewModel(apiManager: DefaultApiManager(urlStringCreator: urlFunc)))
    }
}

func urlFunc(page: Int?) -> String {
    return "https://rickandmortyapi.com/api/character?page=\(page!)"
}
