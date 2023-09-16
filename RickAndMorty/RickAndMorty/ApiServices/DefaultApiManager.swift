//
//  DefultApiManager.swift
//  RickAndMorty
//
//  Created by Vít Nademlejnský on 13.09.2023.
//

import Foundation
import OSLog

class DefaultApiManager: ApiManagerProtocol {
    var pageNumber: Int = 1
    var maxPage: Int = 1
    var urlStringCreator: (Int) -> String
    
    let logger = Logger(subsystem: "Rick and Morty", category: "DefaultApiManager")
    
    required init(urlStringCreator: @escaping (Int) -> String) {
        self.urlStringCreator = urlStringCreator
    }
    
    func retrieveData() async throws -> [Character] {
        let urlString = urlStringCreator(pageNumber)
        
        guard let safeUrl = URL(string: urlString) else {
            throw ApiError.InvalidUrl(urlString: urlString)
        }
        
        do {
            let (data, error) = try await URLSession.shared.data(from: safeUrl)
            
            guard let decodedResponse = try? JSONDecoder().decode(ApiMenuModel.self, from: data) else {
                throw ApiError.DecodingDataError(description: error.description)
            }
            
            if (self.pageNumber == 1) {
                self.maxPage = decodedResponse.info.pages
            }
            
            logger.info("Data retrieved and decoded from page number \(self.pageNumber) out of \(self.maxPage) pages.")
            
            pageNumber += 1
            
            return decodedResponse.results
            
        } catch {
            logger.error("Error fetching posts: \(error)")
            throw ApiError.UrlSessionError(description: error.localizedDescription)
        }
    }
    
    func somePagesLeft() -> Bool {
        return pageNumber <= maxPage
    }
}
