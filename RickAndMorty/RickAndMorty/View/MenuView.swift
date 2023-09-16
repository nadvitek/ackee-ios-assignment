//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Vít Nademlejnský on 08.09.2023.
//

import SwiftUI

struct MenuView: View {
    @StateObject var menuViewModel: MenuViewModel
    
    init() {
        _menuViewModel = StateObject(wrappedValue: MenuViewModel(apiManager: DefaultApiManager(urlStringCreator: urlFunc)))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.bg.ignoresSafeArea()
                VStack(spacing: 15) {
                    if (!menuViewModel.isFocused) {
                        Text(menuViewModel.menuSelected == .Rick ? "Characters" : "Favorites")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    }
                    
                    if menuViewModel.fetchingIsRunning && !menuViewModel.isFocused
                        && !menuViewModel.fetchPage{
                        ProgressView()
                            .frame(maxHeight: .infinity, alignment: .center)
                    } else if menuViewModel.characters.isEmpty && !menuViewModel.isFocused {
                        Text(menuViewModel.menuSelected == .Rick ? "Characters couln't be loaded, try restart."
                             : "No favorites yet")
                        .foregroundColor(.gray)
                        .frame(maxHeight: .infinity, alignment: .center)
                    } else {
                        MenuScrollView()
                            .environmentObject(menuViewModel)
                    }
                }.padding(.top)
                VStack {
                    Spacer()
                    if (!menuViewModel.isFocused) {
                        MenuSwitchView()
                            .environmentObject(menuViewModel)
                    }
                }
            }
        }
        .accentColor(.black)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
