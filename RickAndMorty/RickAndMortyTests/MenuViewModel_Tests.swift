//
//  CharacterViewModel_Tests.swift
//  RickAndMortyTests
//
//  Created by Vít Nademlejnský on 13.09.2023.
//

import XCTest
import Combine
@testable import RickAndMorty

final class MenuViewModel_Tests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @MainActor func test_MenuViewModel_isCharacterFavorite_shouldBeTrue() {
        //ARRANGE
        let menuViewModel = MenuViewModel(apiManager: MockedApiManagerProtocol(urlStringCreator: { i in
            return ""
        }))
        menuViewModel.favoritesIds.insert(2)
        
        //ACT
        let ret = menuViewModel.isCharacterFavorite(Character(id: 1, name: "Rick", status: "Alive", species: "Human", type: "Old", gender: "Man", origin: LocationOrOrigin(name: "Czech Republic"), location: LocationOrOrigin(name: "Prague"), image: "..."))
        
        //ASSERT
        XCTAssertFalse(ret)
    }
    
    @MainActor func test_MenuViewModel_isCharacterFavorite_shouldBeFalse() {
        //ARRANGE
        let menuViewModel = MenuViewModel(apiManager: MockedApiManagerProtocol(urlStringCreator: { i in
            return ""
        }))
        menuViewModel.favoritesIds.insert(1)
        
        //ACT
        let ret = menuViewModel.isCharacterFavorite(Character(id: 1, name: "Rick", status: "Alive", species: "Human", type: "Old", gender: "Man", origin: LocationOrOrigin(name: "Czech Republic"), location: LocationOrOrigin(name: "Prague"), image: "..."))
        
        //ASSERT
        XCTAssertTrue(ret)
    }
    
    @MainActor func test_MenuViewModel_toggleCharacterFavorite_shouldBeInSet() {
        //ARRANGE
        let menuViewModel = MenuViewModel(apiManager: MockedApiManagerProtocol(urlStringCreator: { i in
            return ""
        }))
        
        //ACT
        menuViewModel.toggleCharacterFavorite(Character(id: 1, name: "Rick", status: "Alive", species: "Human", type: "Old", gender: "Man", origin: LocationOrOrigin(name: "Czech Republic"), location: LocationOrOrigin(name: "Prague"), image: "..."))
        
        //ASSERT
        XCTAssertTrue(menuViewModel.favoritesIds.contains(1))
    }
    
    @MainActor func test_MenuViewModel_toggleCharacterFavorite_DoubleToggleShouldntBeInSet() {
        //ARRANGE
        let menuViewModel = MenuViewModel(apiManager: MockedApiManagerProtocol(urlStringCreator: { i in
            return ""
        }))
        
        //ACT
        menuViewModel.toggleCharacterFavorite(Character(id: 1, name: "Rick", status: "Alive", species: "Human", type: "Old", gender: "Man", origin: LocationOrOrigin(name: "Czech Republic"), location: LocationOrOrigin(name: "Prague"), image: "..."))
        menuViewModel.toggleCharacterFavorite(Character(id: 1, name: "Rick", status: "Alive", species: "Human", type: "Old", gender: "Man", origin: LocationOrOrigin(name: "Czech Republic"), location: LocationOrOrigin(name: "Prague"), image: "..."))
        
        //ASSERT
        XCTAssertFalse(menuViewModel.favoritesIds.contains(1))
    }
    
    @MainActor func test_MenuViewModel_processCancelButton_EmptiesTheSearchFieldText() {
        //ARRANGE
        let menuViewModel = MenuViewModel(apiManager: MockedApiManagerProtocol(urlStringCreator: { i in
            return ""
        }))
        
        //ACT
        menuViewModel.searchText = "Hello World!"
        menuViewModel.processCancelButton()
        
        //ASSERT
        XCTAssertTrue(menuViewModel.searchText.isEmpty)
    }
    
    @MainActor func test_MenuViewModel_toggleCharacterFavorite_OneToggleAndDoubleToggleShouldBeOneInSet() {
        //ARRANGE
        let menuViewModel = MenuViewModel(apiManager: MockedApiManagerProtocol(urlStringCreator: { i in
            return ""
        }))
        
        //ACT
        let expectation = XCTestExpectation(description: "Should return character after 3 seconds.")
        
        menuViewModel.$characters
            .dropFirst()
            .sink { chars in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        menuViewModel.menuSwitched(to: .Favorites)
        menuViewModel.toggleCharacterFavorite(Character(id: 1, name: "Rick", status: "Alive", species: "Human", type: "Old", gender: "Man", origin: LocationOrOrigin(name: "Czech Republic"), location: LocationOrOrigin(name: "Prague"), image: "..."))
        menuViewModel.toggleCharacterFavorite(Character(id: 2, name: "Rick", status: "Alive", species: "Human", type: "Old", gender: "Man", origin: LocationOrOrigin(name: "Czech Republic"), location: LocationOrOrigin(name: "Prague"), image: "..."))
        menuViewModel.toggleCharacterFavorite(Character(id: 1, name: "Rick", status: "Alive", species: "Human", type: "Old", gender: "Man", origin: LocationOrOrigin(name: "Czech Republic"), location: LocationOrOrigin(name: "Prague"), image: "..."))
        
        wait(for: [expectation], timeout: 5.0)
        
        //ASSERT
        XCTAssertLessThan(menuViewModel.characters.count, 2)
    }

}
