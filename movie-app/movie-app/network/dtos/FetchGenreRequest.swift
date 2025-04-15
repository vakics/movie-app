//
//  FetchGenreRequest.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 12..
//
import Foundation
import Moya

struct FetchGenreRequest {
    let accessToken: String = Config.bearerToken
    
    func asRequestParams() -> [String: String] {
//        dictionary
        return [:]
    }
}
