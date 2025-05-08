//
//  FavoriteView.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 04..
//

import SwiftUI

struct FavoriteView: View {
    @StateObject private var viewModel = FavoriteViewModell()
    var body: some View {
        NavigationView{
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.movies) { movie in
                        MovieCellView(movie: movie)
                            .frame(height: 277)
                    }
                }
                .padding(.horizontal, LayoutConst.normalPadding)
                .padding(.top, LayoutConst.normalPadding)
            }
            .navigationTitle("favoriteMovies.title")
        }
    }
}

#Preview {
    FavoriteView()
}
