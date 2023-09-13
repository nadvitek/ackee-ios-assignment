//
//  SearchBarView.swift
//  RickAndMorty
//
//  Created by Vít Nademlejnský on 12.09.2023.
//

import SwiftUI

struct SearchBarView: View {
    @EnvironmentObject var menuViewModel: MenuViewModel
    
    @FocusState var focused: Bool
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: .greatestFiniteMagnitude)
                .foregroundColor(.gray.opacity(0.3))
                .overlay {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 20)
                        TextField("Search character", text: $menuViewModel.searchText)
                            .font(.body)
                            .focused($focused)
                            .autocorrectionDisabled()
                        Spacer()
                        if (!menuViewModel.searchText.isEmpty) {
                            Image(systemName: "xmark.circle")
                                .onTapGesture {
                                    menuViewModel.searchText = ""
                                }
                        }
                    }.padding(10)
                }.frame(maxWidth: .infinity)
                .frame(height: 30)
            if (focused) {
                Text("Cancel")
                    .font(.title3)
                    .onTapGesture {
                        focused.toggle()
                        menuViewModel.processCancelButton()
                    }
            }
        }.padding(.bottom, 8)
            .padding(.horizontal)
            .onChange(of: focused) { newValue in
                menuViewModel.focusUpdate(newValue)
            }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView()
            .environmentObject(MenuViewModel(apiManager: DefaultApiManager(urlStringCreator: urlFunc)))
    }
}
