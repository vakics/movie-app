//
//  ProductionCompany.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 13..
//

import Foundation

struct ProductionCompany: Decodable, Identifiable {
    let id: Int
    let logoPath: URL?
    let name: String
    let originCountry: String
    
    var imageUrl: URL? {
        guard let logoPath = logoPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(logoPath)")
    }
    
    init(id: Int,
         logoPath: URL?,
         name: String,
         originCountry: String) {
        self.id = id
        self.logoPath = logoPath
        self.name = name
        self.originCountry = originCountry
    }
    
    init(dto: ProductionCompanyResponse) {
        self.id = dto.id
        self.logoPath = dto.logoPath.flatMap { URL(string: "https://image.tmdb.org/t/p/w185\($0)") }
        self.name = dto.name
        self.originCountry = dto.originCountry
    }
}
extension ProductionCompany: ParticipantItemProtocol {}
