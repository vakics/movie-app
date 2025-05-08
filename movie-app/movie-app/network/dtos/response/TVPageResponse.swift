//
//  TVPageResponse.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 05..
//

struct TVPageResponse: Decodable {
    let page: Int
    let results: [TVResponse]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct TVResponse: Decodable {
    let id: Int
    let name: String
    let firstAirDate: String
    let posterPath: String?
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case firstAirDate = "first_air_date"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
