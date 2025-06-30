//
//  MovieCellView.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 26..
//

import SwiftUI
import Shimmer

struct MediaItemCellView: View {
    let movie: MediaItem
    
    var body: some View {
            if movie.id < 0 {
                VStack {
                    Color.gray
                }
                .frame(height: 100)
                .frame(maxHeight: 180)
                .cornerRadius(12)
                .shimmering()
                .allowsHitTesting(false)
            } else {
                VStack(alignment: .leading, spacing: LayoutConst.smallPadding) {
                    ZStack(alignment: .topLeading) {
                        HStack(alignment: .center) {
                            LoadImageView(url: movie.imageUrl)
                            .frame(height: 100)
                            .frame(maxHeight: 180)
                            .cornerRadius(12)
                        }
                        
                        HStack(spacing: 12.0) {
                            MediaItemLabel(type: .rating(value: movie.rating))
                            MediaItemLabel(type: .voteCount(vote: movie.voteCount))
                        }
                        .padding(LayoutConst.smallPadding)
                        
                    }

                    HStack {
                        VStack(alignment: .leading) {
                            Text(movie.title)
                                .font(Fonts.subheading)
                                .lineLimit(2)
                                .truncationMode(.tail)
                                .frame(maxWidth: 150, alignment: .leading)
                            
                            Text("\(movie.year)")
                                .font(Fonts.paragraph)
                            
                            Text("\(movie.duration)")
                                .font(Fonts.caption)
                        }
                        
                        Spacer()
                        
                        Image(.playButton)
                    }
                }
                .contentShape(Rectangle())
            }
            
        }
}

