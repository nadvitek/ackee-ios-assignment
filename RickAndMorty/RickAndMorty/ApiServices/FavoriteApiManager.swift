//
//  FavoriteApiManager.swift
//  RickAndMorty
//
//  Created by Vít Nademlejnský on 13.09.2023.
//

import Foundation
import OSLog

class FavoriteApiManager: ApiManagerProtocol {
    var urlStringCreator: (Int) -> String
    
    let logger = Logger(subsystem: "Rick and Morty", category: "FavoriteApiManager")
    
    required init(urlStringCreator: @escaping (Int) -> String) {
        self.urlStringCreator = urlStringCreator
    }
    
    func retrieveData() async throws -> [Character] {
        let urlString = urlStringCreator(0)
        
        guard let safeUrl = URL(string: urlString) else {
            throw ApiError.InvalidUrl(urlString: urlString)
        }
        
        do {
            let (data, error) = try await URLSession.shared.data(from: safeUrl)
            
            guard let decodedResponse = try? JSONDecoder().decode([Character].self, from: data) else {
                throw ApiError.DecodingDataError(description: error.description)
            }
                
            return decodedResponse
            
        } catch {
            throw ApiError.UrlSessionError(description: error.localizedDescription)
        }
    }
    
    func somePagesLeft() -> Bool {
        return false
    }
}
