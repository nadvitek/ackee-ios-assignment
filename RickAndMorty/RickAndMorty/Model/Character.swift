//
//  Character.swift
//  RickAndMorty
//
//  Created by Vít Nademlejnský on 08.09.2023.
//

import Foundation

struct Character: Hashable, Identifiable, Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: LocationOrOrigin
    let location: LocationOrOrigin
    let image: String
}

struct LocationOrOrigin: Decodable, Hashable {
    let name: String
}
