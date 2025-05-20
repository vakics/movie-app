//
//  CastMemberResponse.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 14..
//


struct CastMemberResponse: Codable, Identifiable {
    let id: Int
    let name: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePath = "profile_path"
    }
}