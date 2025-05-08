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
                    AsyncImage(url: movie.imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ZStack {
                                Color.gray.opacity(0.3)
                                ProgressView()
                            }

                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()

                        case .failure:
                            ZStack {
                                Color.red.opacity(0.3)
                                Image(systemName: "photo")
                                    .foregroundColor(.white)
                            }

                        default:
                            EmptyView()
                        }
                    }
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

