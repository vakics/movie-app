//
//  ContentView.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 06..
//

import SwiftUI

struct GenreSectionView: View {
    var type: GenreType
    @StateObject private var viewModel  = GenreSectionViewModelImp()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack{
                        Spacer()
                        Image(.redCirclePart)
                    }
                    Spacer()
                }.ignoresSafeArea()
                
                List{
                    if viewModel.motdMovie == nil {
                        GenreMotdCell(mediaItem: MediaItemDetail(id: -5))
                            .background(Color.clear)
                            .listStyle(.plain)
                    }
                    if let motd = viewModel.motdMovie {
                        GenreMotdCell(mediaItem: motd)
                            .background(Color.clear)
                            .listStyle(.plain)
                    }
                    ForEach(viewModel.genres) {genre in
                        ZStack {
                            NavigationLink(destination: MovieListView(showType: type, genre: genre)) {
                                EmptyView()
                            }.opacity(0)
                            let mediaItems = viewModel.getMediaItemsByGenre(genre.id)
                            MediaItemListByGenre(genre: genre, mediaItems: mediaItems)
                                .onAppear{
                                    if viewModel.mediaItemsByGenre[genre.id] == nil{
                                        viewModel.loadMediaItems(genreId: genre.id, typeSubject: viewModel.typeSubject)
                                    }
                                }
                            
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    
                }
                .accessibilityLabel("testCollectionView")
                .listStyle(.plain)
                .navigationTitle(type == .movie ? "Movie" : "Tv Show")
                
                
            }
            .onAppear {
                //                a task felel a háttérben futó hívásokért
                viewModel.typeSubject.send(type)
                viewModel.loadGenres()
                viewModel.genreAppeared()
                
            }
            .showAlert(model: $viewModel.alertModel)
        }
    }
}

#Preview {
    GenreSectionView(type: .movie)
}
