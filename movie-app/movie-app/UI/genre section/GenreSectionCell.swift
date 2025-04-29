//
//  GenreSectionCell.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 26..
//

import SwiftUICore
import SwiftUI

struct GenreSectionCell: View {
    var genre: Genre;
    var body : some View {
        HStack {
            Text(genre.name).font(Fonts.title)
                .foregroundStyle(.primary)
            Spacer()
            Image(.rightArrow)
            }
    }
    
}
