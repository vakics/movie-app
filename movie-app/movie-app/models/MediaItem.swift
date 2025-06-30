//
//  Movie.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 15..
//

import Foundation

struct MediaItemPage {
    let page: Int
    let totalPages: Int
    let mediaItems: [MediaItem]
    
    init(){
        self.page = 0
        self.totalPages = 0
        self.mediaItems = []
    }
    
    init(dto: MoviePageResponse) {
        self.page = dto.page
        self.totalPages = dto.totalPages
        self.mediaItems = dto.results.map(MediaItem.init(dto:))
    }
    
    init(dto: TVPageResponse) {
        self.page = dto.page
        self.totalPages = dto.totalPages
        self.mediaItems = dto.results.map(MediaItem.init(dto:))
    }
}

struct MediaItem: Identifiable {
    var id: Int
    let title: String
    let year: String
    let duration: String
    let imageUrl: URL?
    let rating: Double
    let voteCount: Int
    let showType: MediaItemType
    
    init(id: Int = -1) {
        self.id = id
        self.title = ""
        self.year = ""
        self.duration = ""
        self.imageUrl = nil
        self.rating = 0
        self.voteCount = 0
        self.showType = .unknown
    }
    
    init(id: Int, title: String, year: String, duration: String, imageUrl: URL?, rating: Double, voteCount: Int) {
        self.id = id
        self.title = title
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = rating
        self.voteCount = voteCount
        self.showType = .unknown
    }
    
    init(id: Int, title: String, year: String, duration: String, imageUrl: URL?, rating: Double, voteCount: Int, showType: MediaItemType) {
        self.id = id
        self.title = title
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = rating
        self.voteCount = voteCount
        self.showType = showType
    }
    
    init(dto: MovieResponse) {
        let releaseDate: String? = dto.releaseDate
        let prefixedYear: Substring = releaseDate?.prefix(4) ?? "-"
        let year = String(prefixedYear)
        let duration = "1h 25min" // TODO: placeholder – ha lesz ilyen adat, cserélhető
        
        var imageUrl: URL? {
            dto.posterPath.flatMap {
                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
            }
        }
        
        self.id = dto.id
        self.title = dto.title
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = dto.voteAverage ?? 0.0
        self.voteCount = dto.voteCount ?? 0
        self.showType = .movie
    }
    
    init(dto: TVResponse) {
        let releaseDate: String? = dto.firstAirDate
        let prefixedYear: Substring = releaseDate?.prefix(4) ?? "-"
        let year = String(prefixedYear)
        let duration = "1h 25min" // TODO: placeholder – ha lesz ilyen adat, cserélhető
        
        var imageUrl: URL? {
            dto.posterPath.flatMap {
                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
            }
        }
        
        self.id = dto.id
        self.title = dto.name
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = dto.voteAverage ?? 0.0
        self.voteCount = dto.voteCount ?? 0
        self.showType = .tvShow
    }
    
    init(detail: MediaItemDetail) {
        self.id = detail.id
        self.title = detail.title
        self.year = detail.year
        self.duration = "1h 25min"
        self.imageUrl = detail.imageUrl
        self.rating = detail.rating
        self.voteCount = detail.voteCount
        self.showType = detail.showType
    }
    
    init(dto: CombinedMediaItemResponse){
        let releaseDate: String? = dto.releaseDate ?? dto.firstAirDate
        let prefixedYear: Substring = releaseDate?.prefix(4) ?? "-"
        let year = String(prefixedYear)
        let duration = "1h 25min"
        
        var imageUrl: URL? {
            dto.posterPath.flatMap {
                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
            }
        }
        self.id = dto.id
        self.title = dto.originalTitle ?? dto.originalName ?? "N/A"
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = dto.voteAverage
        self.voteCount = dto.voteCount
        switch dto.mediaType{
        case "movie":
            self.showType = .movie
        case "tv":
            self.showType = .tvShow
        default:
            self.showType = .unknown
        }
    }
    
}
