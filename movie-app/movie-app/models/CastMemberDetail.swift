//
//  CastMemberDetail.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 06. 14..
//

import Foundation
struct CastDetail: Codable, Identifiable{
    let id: Int
    let name: String
    let biography: String
    let originPlace: String?
    let popularity: Double
    let imageURL: URL?
    let birthYear: String?
    
    init(){
        self.id = 0
        self.name = ""
        self.biography = ""
        self.originPlace = nil
        self.popularity = 0.0
        self.imageURL = nil
        self.birthYear = nil
    }
    
    init(id: Int, name: String, biography: String, originPlace: String?, popularity: Double, imagePath: URL?, birthYear: String?) {
        self.id = id
        self.name = name
        self.biography = biography
        self.originPlace = originPlace
        self.popularity = popularity
        self.imageURL = imagePath
        self.birthYear = birthYear
    }
    
    init(dto: CastMemberDetailResponse){
        id = dto.id
        name = dto.name
        biography = dto.biography
        popularity = dto.popularity
        imageURL = dto.profileImageURL
        originPlace = dto.placeOfBirth
        birthYear = dto.birthday
    }
    
    init(dto: CompanyDetailResponse) {
        id = dto.id
        imageURL = dto.logoURL
        name = dto.name
        biography = dto.description ?? ""
        popularity = 0
        originPlace = dto.originCountry
        birthYear = nil
    }
    
}
