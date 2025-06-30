//
//  FetchRandomMediaItems.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 06. 30..
//

struct FetchRandomMediaItems: Encodable{
    let accessToken: String = Config.bearerToken
    
    func asRequestParams() -> [String: Any] {
        return [:]
    }
}
