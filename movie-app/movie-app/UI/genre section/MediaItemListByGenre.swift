//
//  MediaItemListByGenre.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 31..
//

import SwiftUI
import Shimmer

struct MediaItemListByGenre: View {
    let genre: Genre
    let mediaItems: [MediaItem]
    var body: some View {
        VStack{
            GenreSectionCell(genre: genre)
            ScrollView(.horizontal){
                LazyHStack(spacing: 20){
                    ForEach(mediaItems){mediaItem in
                        NavigationLink(destination: DetailView(mediaItem: mediaItem)){
                            if mediaItem.id < 0{
                                Rectangle()
                                    .frame(width: 200, height: 100)
                                    .shimmering()
                            } else {
                                MediaItemCellView(movie: mediaItem)
                                    .frame(width: 200)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .listRowBackground(Color.clear)
        }
    }
}
