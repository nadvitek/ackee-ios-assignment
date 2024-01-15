//
//  ApiManagerProtocol.swift
//  RickAndMorty
//
//  Created by Vít Nademlejnský on 13.09.2023.
//

import Foundation

protocol ApiManagerProtocol {
    var urlStringCreator: (Int) -> String { get }
    
    init(urlStringCreator: @escaping (Int) -> String)
    
    func retrieveData() async throws -> [Character]
    func somePagesLeft() -> Bool
}
