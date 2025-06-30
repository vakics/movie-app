//
//  MovieListView.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 15..
//
import SwiftUI

struct MediaItemListView: View {
    var showType: MediaItemType
    @StateObject private var viewModel = MediaItemListViewModel()
    let genre: Genre
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: LayoutConst.largePadding) {
                ForEach(viewModel.mediaItems.indices, id: \.self) { index in
                    let mediaItem = viewModel.mediaItems[index]
                    NavigationLink(destination: DetailView(mediaItem: mediaItem)) {
                        MediaItemCellView(movie: mediaItem)
                            .onAppear {
                                if index == viewModel.mediaItems.count - 1 {
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
        .refreshable {
            viewModel.mediaItems = []
            viewModel.actualPage = 1
            viewModel.genreIdSubject.send(genre.id)
        }
        .navigationTitle(genre.name)
        .showAlert(model: $viewModel.alertModel)
        .onAppear {
            viewModel.typeSubject.send(showType)
            viewModel.genreIdSubject.send(genre.id)
        }
    }
}
