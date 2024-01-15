//
//  CharacterViewModel.swift
//  RickAndMorty
//
//  Created by Vít Nademlejnský on 08.09.2023.
//

import Foundation
import OSLog
import Combine

@MainActor class MenuViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var favoritesIds = Set<Int>()
    
    @Published var searchText = ""
    @Published var menuSelected: MenuSelected = .Rick
    
    @Published var fetchPage = false
    @Published private(set) var isFocused = false
    @Published private(set) var fetchingIsRunning = true

    private var searchCancellable: AnyCancellable? = nil
    private var apiManager: ApiManagerProtocol
    private let logger = Logger(subsystem: "Rick and Morty", category: "CharacterViewModel")
    
    init(apiManager: ApiManagerProtocol) {
        self.apiManager = apiManager

        searchCancellable = $searchText
            .removeDuplicates()
            .debounce(for: 0.6, scheduler: RunLoop.main)
            .sink(receiveValue: { val in
                self.characters = []
                if !self.isFocused || !val.isEmpty {
                    self.switchApiStrategy()
                    self.dataTask()
                }
            })
    }
    
    func isCharacterFavorite(_ char: Character) -> Bool {
        return favoritesIds.contains(char.id)
    }
    
    func toggleCharacterFavorite(_ char: Character) {
        let charId = char.id
        if favoritesIds.contains(charId) {
            favoritesIds.remove(charId)
            if menuSelected == .Favorites {
                self.fetchingIsRunning = true
                characters = []
                dataTask()
            }
        } else {
            favoritesIds.insert(charId)
        }
    }
    
    func menuSwitched(to menuSelected: MenuSelected) {
        if self.menuSelected == menuSelected {
            return
        }
        
        self.menuSelected = menuSelected
        switchApiStrategy()
        dataTask()
    }
    
    func focusUpdate(_ to: Bool) {
        if to {
            self.characters = []
        }
        self.isFocused = to
    }
    
    func processCancelButton() {
        switchApiStrategy()
        if searchText.isEmpty {
            dataTask()
        } else {
            searchText = ""
        }
    }
}

//MARK: - Data functions
extension MenuViewModel {
    
    private func switchApiStrategy() {
        self.fetchingIsRunning = true
        characters = []
        if (menuSelected == .Favorites) {
            logger.info("Switching API strategy to favorite.")
            apiManager = FavoriteApiManager(urlStringCreator: {_ in
                return "https://rickandmortyapi.com/api/character/\(self.favoritesIds.sorted().description.replacingOccurrences(of: " ", with: ""))"
            })
        } else if (searchText.isEmpty) {
            logger.info("Switching API strategy to default.")
            apiManager = DefaultApiManager(urlStringCreator: { page in
                return "https://rickandmortyapi.com/api/character?page=\(page)"
            })
        } else {
            logger.info("Switching API strategy to search.")
            apiManager = DefaultApiManager(urlStringCreator: { page in
                return "https://rickandmortyapi.com/api/character/?page=\(page)&name=\(self.searchText)"
            })
        }
    }
    
    private func dataTask() {
        Task {
            do {
                characters.append(contentsOf: try await apiManager.retrieveData())
            } catch {
                logger.error("Data couldn't be retrieved.")
            }
            fetchingIsRunning = false
            fetchPage = false
        }
    }
    
    func fetchAnotherPage() {
        if (fetchingIsRunning) {
            return
        }
        
        if (apiManager.somePagesLeft()) {
            logger.info("Fetching another page.")
            fetchingIsRunning = true
            dataTask()
        } else {
            fetchPage = false
            logger.info("There are no pages left.")
        }
    }
}
