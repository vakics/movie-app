//
//  CombinedMediaItem.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 06. 25..
//

struct CombinedMediaItem{
    let mediaItem: MediaItem
    let originalTitle: String
    let showType: GenreType
    let character: String
    
    init(mediaItem: MediaItem, originalTitle: String, showType: GenreType, character: String) {
        self.mediaItem = mediaItem
        self.originalTitle = originalTitle
        self.showType = showType
        self.character = character
    }
    
    init(dto: CombinedMediaItemResponse){
        self.mediaItem = MediaItem(dto: dto)
        switch dto.mediaType{
        case "movie":
            self.showType = .movie
        case "tv":
            self.showType = .tvShow
        default:
            self.showType = .movie
        }
        self.character = dto.character
        self.originalTitle = dto.originalTitle ?? dto.originalName ?? "N/A"
    }
}
