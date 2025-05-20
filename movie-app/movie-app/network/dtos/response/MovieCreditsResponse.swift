//
//  MovieCreditsResponse.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 13..
//


import Foundation

struct MovieCreditsResponse: Codable {
    let id: Int
    let cast: [CastMemberResponse]
    
    enum CodingKeys: String, CodingKey {
        case id
        case cast
    }
}
