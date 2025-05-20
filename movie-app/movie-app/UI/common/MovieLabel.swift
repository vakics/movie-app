//
//  MovieLabel.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 26..
//

import SwiftUI

enum MovieLabelType {
    case rating(value: Double)
    case voteCount(vote: Int)
    case popularity(popularity: Double)
    case adult(adult: Bool)
}

struct MovieLabel: View {
    let type: MovieLabelType
    
    var body: some View {
        var imageRes: ImageResource
        var text: String
        switch type {
        case .rating(let value):
            text = String(format: "%.1f", value)
            imageRes = .star
        case .voteCount(let vote):
            text = "\(vote)"
            imageRes = .heart
        case .popularity(let popularity):
            text = "\(popularity)"
            imageRes = .person
        case .adult(let adult):
            text = adult ? "Available" : "Unavailable"
            imageRes = .closedCaption
        }
        return HStack(spacing: 6) {
            Image(imageRes)
            Text(LocalizedStringKey(text))
                .font(Fonts.labelBold).foregroundStyle(.white)
        }
        .padding(6)
        .background(Color.black.opacity(0.5))
        .cornerRadius(12)
    }
}
