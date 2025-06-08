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
                    LazyVGrid(columns: columns, spacing: LayoutConst.largePadding) {
                        ForEach(viewModel.movies.indices, id: \.self) { index in
                            let movie = viewModel.movies[index]
                            NavigationLink(destination: DetailView(mediaItem: movie)) {
                                MovieCellView(movie: movie)
                                    .onAppear {
                                        if index == viewModel.movies.count - 1 {
                                            viewModel.reachedBottomSubject.send()
                                        }
                                    }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, LayoutConst.normalPadding)
                    .padding(.top, LayoutConst.normalPadding)
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .padding()
                    }
                }
                .navigationTitle(genre.name)
                .showAlert(model: $viewModel.alertModel)
                .onAppear {
                    viewModel.typeSubject.send(showType)
                    viewModel.genreIdSubject.send(genre.id)
                }
            }
}
