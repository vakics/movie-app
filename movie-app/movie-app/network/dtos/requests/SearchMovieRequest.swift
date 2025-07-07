//
//  SearchMovieRequest.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 17..
//

struct SearchMoviesRequest: LocalizedRequestable {
    let accessToken: String = Config.bearerToken
    let query: String
    
    func asRequestParams() -> [String: Any] {
        return ["query": query] + languageParam
    }
}
