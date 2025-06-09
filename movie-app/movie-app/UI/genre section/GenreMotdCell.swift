//
//  GenreMotdCell.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 06. 03..
//


import SwiftUI
import Shimmer

struct GenreMotdCell: View {
    let mediaItem: MediaItemDetail
    
    var body: some View {
        if mediaItem.id<0{
            Rectangle()
                .frame(width: 370, height: 185)
                .shimmering()
        } else {
            ZStack(alignment: .bottomLeading) {
                LoadImageView(url: mediaItem.imageUrl)
                    .frame(width: 370, height: 185)
                    .cornerRadius(12)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(mediaItem.genreList)
                            .font(Fonts.paragraphList)
                        Text(mediaItem.title)
                            .font(Fonts.title)
                    }
                    .padding(LayoutConst.normalPadding)
                    
                    Spacer()
                    
                    Image(.playButton)
                        .frame(width: 48, height: 48)
                        .padding(LayoutConst.normalPadding)
                }
            }
            .padding(LayoutConst.maxPadding)
            .background(Color.clear)
        }
    }
}
