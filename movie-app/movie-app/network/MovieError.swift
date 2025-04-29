//
//  MovieError.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 26..
//

import Foundation

enum MovieError: Error{
    case invalidApiKeyError(message: String)
    case clientError
    case unexpectedError
    
    var domain: String{
        switch self{
        case .invalidApiKeyError, .unexpectedError, .clientError:
            return "MovieError"
        }
    }
}

extension MovieError: LocalizedError{
    var errorDescription: String?{
        switch self{
        case .invalidApiKeyError(let message):
            return message
        case .unexpectedError:
            return "Unexpected error"
        case .clientError:
            return "Client error"
        }
    }
}
