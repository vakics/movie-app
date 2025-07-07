//
//  StarRatingView.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 23..
//


import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Int
    var starSize: CGFloat = 40.0
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<5, id: \.self) { index in
                StarView(index: index,
                         isFilled: index <= rating,
                         size: starSize,
                         onTap: {
                    rating = index
                })
            }
        }
    }
}
