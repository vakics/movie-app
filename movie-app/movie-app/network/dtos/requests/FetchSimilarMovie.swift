//
//  FetchSimilarMovie.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 06. 23..
//

struct FetchSimilarMovie: LocalizedRequestable{
    let accessToken: String = Config.bearerToken
    let movieId: Int
    let pageNumber: Int
    
    func asRequestParams() -> [String: Any] {
        return ["page": pageNumber] + languageParam
    }
}
