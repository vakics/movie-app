//
//  MediaItemEntity.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 17..
//

import RealmSwift
import Foundation

class MediaItemEntity: Object{
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String
    @Persisted var year: String
    @Persisted var duration: String
    @Persisted var imageUrl: String?
    @Persisted var rating: Double
    @Persisted var voteCount: Int

    
    
}

extension MediaItemEntity{
    var toDomain: MediaItem {
        MediaItem(id: id, title: title, year: year, duration: duration, imageUrl: imageUrl.flatMap(URL.init(string:)), rating: rating, voteCount: voteCount)
    }
    convenience init(from domains: MediaItem){
        self.init()
        self.title = domains.title
        self.year = domains.year
        self.duration = domains.duration
        self.imageUrl = domains.imageUrl?.absoluteString
        self.rating = domains.rating
        self.voteCount = domains.voteCount
    }
}


