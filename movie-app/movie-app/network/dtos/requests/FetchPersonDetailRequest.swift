//
//  FetchPersonDetailRequest.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 06. 14..
//

struct FetchCastMemberDetailRequest: Encodable{
    let accessToken: String = Config.bearerToken
    let memberId: Int
    
    func asRequestParams() -> [String: Any] {
        return [:]
    }
}
