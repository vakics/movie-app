//
//  MovieListView.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 15..
//
import SwiftUI

struct MovieListView: View {
    var showType: GenreType
    @StateObject private var viewModel = MovieListViewModel()
    let genre: Genre
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 24) {
                ForEach(viewModel.movies) { movie in
                    NavigationLink(destination: DetailView(mediaItem: movie)){
                        MovieCellView(movie: movie)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, LayoutConst.normalPadding)
            .padding(.top, LayoutConst.normalPadding)
        }
        .navigationTitle(genre.name)
        .showAlert(model: $viewModel.alertModel)
        .onAppear {
            Task {
                viewModel.genreIdSubject.send(genre.id)
                viewModel.typeSubject.send(showType)
            }
        }
    }
}
