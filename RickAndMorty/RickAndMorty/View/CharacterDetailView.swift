//
//  CharacterDetailView.swift
//  RickAndMorty
//
//  Created by Vít Nademlejnský on 08.09.2023.
//

import SwiftUI

struct CharacterDetailView: View {
    @EnvironmentObject var menuViewModel: MenuViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    let char: Character
    
    var body: some View {
        ZStack {
            Color.bg.ignoresSafeArea()
            VStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.item)
                    .frame(maxWidth: .infinity)
                    .frame(height:  UIScreen.main.bounds.height * (verticalSizeClass == .compact ? 0.85 : 0.75))
                    .shadow(radius: 20)
                    .padding()
                    .overlay {
                        VStack() {
                            upperPart
                            Rectangle()
                                .foregroundColor(.gray.opacity(0.5))
                                .frame(maxWidth: .infinity)
                                .frame(height: abs(1))
                            Spacer()
                            lowerPart
                            Spacer()
                        }.padding()
                }
                Spacer()
            }
        }.toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Image(systemName: "chevron.backward")
                    Text(char.name)
                }
                .onTapGesture {
                    menuViewModel.searchText = ""
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    var upperPart: some View {
        HStack(alignment: .top, spacing: 0){
            AsyncImage(url: URL(string: char.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
            } placeholder: {
                ProgressView()
            }.padding()
            VStack(alignment: .leading, spacing: 15) {
                HStack{
                    Text("Name")
                        .foregroundColor(.gray)
                        .font(.title3)
                    Spacer()
                    Image(systemName: menuViewModel.isCharacterFavorite(char) ? "star.fill" : "star")
                        .resizable()
                        .foregroundColor(menuViewModel.isCharacterFavorite(char) ? .selected : .gray)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                        .padding(.horizontal)
                        .onTapGesture {
                            menuViewModel.toggleCharacterFavorite(char)
                        }
                }.padding(.top)
                Text(char.name)
                    .fontWeight(.bold)
                    .font(.title3)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: 120, alignment: .leading)
            }
        }
    }
    
    var lowerPart: some View {
        VStack(alignment: .leading, spacing: UIScreen.main.bounds.height * (verticalSizeClass == .compact ? 0.025 : 0.035)) {
            generateInfoHstack(title: "Status", value: char.status)
            generateInfoHstack(title: "Species", value: char.species)
            generateInfoHstack(title: "Type", value: char.type)
            generateInfoHstack(title: "Gender", value: char.gender)
            generateInfoHstack(title: "Origin", value: char.origin.name)
            generateInfoHstack(title: "Location", value: char.location.name)
        }.frame(height: UIScreen.main.bounds.height * 0.44)
            .padding(.horizontal, 30)
            .padding(.bottom, 10)
    }
    
    func generateTitleText(text: String) -> some View {
        return Text(text)
            .foregroundColor(.gray)
            .font(.system(size: 16))
            .frame(width: 75, alignment: .leading)
    }
    
    func generateValueText(text: String) -> some View {
        return Text(text.isEmpty ? "-" : text)
            .fontWeight(.bold)
            .font(.system(size: 16))
            .frame(maxWidth: 1000, alignment: .leading)
            .multilineTextAlignment(.leading)
    }
    
    func generateInfoHstack(title: String, value: String) -> some View {
        return HStack(alignment: .top, spacing: 30) {
            generateTitleText(text: title)
            generateValueText(text: value)
        }
    }
}

struct CharacterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterDetailView(char: Character(id: 1, name: "Aa", status: "BB", species: "CC", type: "DD", gender: "EE", origin: LocationOrOrigin(name: "Earth (Replacement Dimension)"), location: LocationOrOrigin(name: ""), image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"))
            .environmentObject(MenuViewModel(apiManager: DefaultApiManager(urlStringCreator: urlFunc)))
    }
}
