//
//  MenuSwitchView.swift
//  RickAndMorty
//
//  Created by Vít Nademlejnský on 08.09.2023.
//

import SwiftUI

struct MenuSwitchView: View {
    @EnvironmentObject var menuViewModel: MenuViewModel
    
    var body: some View {
        RoundedRectangle(cornerRadius: .greatestFiniteMagnitude)
            .frame(width: 200, height: 80)
            .foregroundColor(.item)
            .shadow(radius: 20)
            .overlay {
                HStack(spacing: 35) {
                    Image(systemName: "brain.head.profile")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 38)
                        .foregroundColor(menuViewModel.menuSelected == .Rick ? .selected : .gray)
                        .onTapGesture {
                            menuViewModel.menuSwitched(to: .Rick)
                        }
                    Image(systemName: "star")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 38)
                        .foregroundColor(menuViewModel.menuSelected == .Favorites ? .selected : .gray)
                        .onTapGesture {
                            menuViewModel.menuSwitched(to: .Favorites)
                        }
                }
            }.padding(30)
    }
}

struct MenuSwitchView_Previews: PreviewProvider {
    static var previews: some View {
        MenuSwitchView()
            .environmentObject(MenuViewModel(apiManager: DefaultApiManager(urlStringCreator: urlFunc)))
    }
}
