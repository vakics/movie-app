//
//  FetchMovieRequest.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 15..
//

struct FetchMoviesRequest: LocalizedRequestable {
    let accessToken: String = Config.bearerToken
    let genreId: Int
    let pageNumber: Int
    
    func asRequestParams() -> [String: Any] {
        return ["with_genres": genreId, "page": pageNumber] + languageParam
    }
}
