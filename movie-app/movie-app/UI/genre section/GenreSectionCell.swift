//
//  GenreSectionCell.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 26..
//

import SwiftUICore
import SwiftUI

struct GenreSectionCell: View {
    var genre: Genre
    @State var isExpanded: Bool = false
    
    var body : some View {
        HStack {
            Text(genre.name).font(Fonts.title)
                .foregroundStyle(.primary)
            Spacer()
            RotatingArrow(isExpanded: isExpanded)
                .onTapGesture {
                    isExpanded.toggle()
                }
        }
    }
}
