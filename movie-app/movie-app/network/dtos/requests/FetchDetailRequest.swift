//
//  FetchDetailRequest.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 10..
//

struct FetchDetailRequest{
    let accessToken: String = Config.bearerToken
    let mediaId: Int
    
    func asRequestParams() -> [String: Any] {
        return [:]
    }
}
