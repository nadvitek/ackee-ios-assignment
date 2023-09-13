//
//  MockedApiManager.swift
//  RickAndMorty
//
//  Created by Vít Nademlejnský on 13.09.2023.
//

import Foundation

class MockedApiManagerProtocol: ApiManagerProtocol {
    var urlStringCreator: (Int) -> String
    
    let testData: [Character] = [
        .init(id: 1, name: "Rick", status: "Alive", species: "Human", type: "Old", gender: "Man", origin: LocationOrOrigin(name: "Czech Republic"), location: LocationOrOrigin(name: "Prague"), image: "..."),
        .init(id: 2, name: "Morty", status: "Alive", species: "Human", type: "Young", gender: "Man", origin: LocationOrOrigin(name: "Czech Republic"), location: LocationOrOrigin(name: "Prague"), image: "...")
    ]
    
    required init(urlStringCreator: @escaping (Int) -> String) {
        self.urlStringCreator = urlStringCreator
    }
    
    func retrieveData() async throws -> [Character] {
        return testData
    }
    
    func somePagesLeft() -> Bool {
        return false
    }
    
    
}
