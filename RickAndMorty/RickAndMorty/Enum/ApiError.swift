//
//  ApiError.swift
//  RickAndMorty
//
//  Created by Vít Nademlejnský on 13.09.2023.
//

import Foundation

enum ApiError: Error {
    // Throw when an invalid URL is used
    case InvalidUrl(urlString: String)
    
    // Throw when JSON Decoder can't decode data from API
    case DecodingDataError(description: String)
    
    // Throw when Url Session fails
    case UrlSessionError(description: String)
}

extension ApiError: CustomStringConvertible {
    var description: String {
            switch self {
            case .InvalidUrl(let urlString):
                return "Error in url initialization. - \(urlString)"
            case .DecodingDataError(let description):
                return "Problem during decoding process - \(description)"
            case .UrlSessionError(let description):
                return "Error during URL session - \(description)"
            }
        }
}
