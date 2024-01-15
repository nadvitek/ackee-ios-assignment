//
//  ApiMenuModel.swift
//  RickAndMorty
//
//  Created by Vít Nademlejnský on 09.09.2023.
//

import Foundation

struct ApiMenuModel: Decodable {
    let info: Info
    let results: [Character]
}

struct Info: Decodable {
    let pages: Int
}
