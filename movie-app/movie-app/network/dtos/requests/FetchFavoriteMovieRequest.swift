//
//  FetchFavoriteMovieRequest.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 06..
//

struct  FetchFavoriteMovieRequest{
    let accessToken: String = Config.bearerToken
    let accountId: Int = 21889570
    
    func asRequestParams()->[String: Any]{
        return [:]
    }
}
