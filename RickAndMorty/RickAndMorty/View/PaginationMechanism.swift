//
//  PaginationMechanism.swift
//  RickAndMorty
//
//  Created by Vít Nademlejnský on 12.09.2023.
//

import SwiftUI

struct PaginationMechanism: View {
    @EnvironmentObject var menuViewModel: MenuViewModel
    
    var body: some View {
        Group {
            if menuViewModel.fetchPage && menuViewModel.menuSelected == .Rick {
                ProgressView()
                    .padding(.vertical)
                    .onAppear {
                        menuViewModel.fetchAnotherPage()
                    }
            } else {
                GeometryReader { geo -> Color in
                    let minY = geo.frame(in: .global).minY
                    
                    let height = UIScreen.main.bounds.height / 1.3
                    
                    if !menuViewModel.characters.isEmpty && minY < height {
                        DispatchQueue.main.async {
                            menuViewModel.fetchPage = true
                        }
                    }
                    
                    return Color.clear
                }
            }
        }
    }
}
