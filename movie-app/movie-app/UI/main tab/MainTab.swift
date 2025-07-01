//
//  MainTab.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 13..
//

import SwiftUI

struct MainTab: View {
    let options: [String] = ["mainTab.movie", "mainTab.tv"]
    @ViewBuilder
    func declareDestination(item: String) -> some View {
        switch item {
        case "mainTab.movie":
            GenreSectionView(type: .movie)
        case "mainTab.tv":
            GenreSectionView(type: .tvShow)
        default:
            EmptyView()
        }
    }
    var body: some View {
        NavigationView{
            List(options, id: \.self) { option in
                ZStack {
                    NavigationLink(destination: declareDestination(item: option)) {
                        Text(option.localized())
                    }.opacity(0)

                HStack {
                    Text(option.localized()).font(Fonts.title)
                        .foregroundStyle(.primary)
                    Spacer()
                    Image(.rightArrow)
                    }
                                    
                }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
            .navigationTitle("mainTab.title".localized())
                .accessibilityLabel("genreSectionCollectionView")
        }
    }
}

#Preview {
    MainTab()
}
