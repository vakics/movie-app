//
//  MovieError.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 26..
//

import Foundation

enum MovieError: Error {
    case invalidApiKeyError(message: String)
    case clientError
    case unexpectedError
    case noInternetError
    case mappingError(message: String)
    case serverError
    
    var domain: String {
        switch self {
        case .invalidApiKeyError, .unexpectedError, .clientError, .mappingError, .noInternetError, .serverError:
            return "MovieError"
        }
    }
}

extension MovieError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .invalidApiKeyError(let message):
            return message
        case .mappingError(let message):
            return message
        case .clientError:
            return "Client Error Description"
        case .unexpectedError:
            return "Unexpected error"
        case .noInternetError:
            return "No internet"
        case .serverError:
            return "Server error"
        }
    }
}
