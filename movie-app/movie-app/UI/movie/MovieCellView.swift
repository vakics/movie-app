//
//  MovieCellView.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 26..
//

import SwiftUI

struct MovieCellView: View {
    let movie: MediaItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: LayoutConst.smallPadding) {
            ZStack(alignment: .topLeading) {
                HStack(alignment: .center) {
                    LoadImageView(url: movie.imageUrl)
                        .frame(height: 150)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .cornerRadius(12)
                }
                
                HStack(spacing: 12) {
                    MovieLabel(type: .rating(value: movie.rating))
                    MovieLabel(type: .voteCount(vote: movie.voteCount))
                }.padding(LayoutConst.smallPadding)
            }
            Text(movie.title)
                .font(Fonts.subheading)
                .lineLimit(2)
            
            Text("\(movie.year)")
                .font(Fonts.paragraph)
            
            Text("\(movie.duration)")
                .font(Fonts.caption)
            
            Spacer()
            
        }
        
    }
}

