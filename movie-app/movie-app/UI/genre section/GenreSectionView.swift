//
//  ContentView.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 06..
//

import SwiftUI

struct GenreSectionView: View {
    var type: GenreType
    @StateObject private var viewModel  = GenreSectionViewModel()
    
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
                List(viewModel.genres) {genre in
                    ZStack {
                        NavigationLink(destination: MovieListView(showType: type, genre: genre)) {
                            EmptyView()
                        }.opacity(0)
                        
                        GenreSectionCell(genre: genre)
                        
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .accessibilityLabel("testCollectionView")
                .listStyle(.plain)
                .navigationTitle(type == .movie ? "Movie" : "Tv Show")
            }
            .onAppear {
                //                a task felel a háttérben futó hívásokért
                viewModel.typeSubject.send(type)
                
            }
            .showAlert(model: $viewModel.alertModel)
        }
    }
}

#Preview {
    GenreSectionView(type: .movie)
}
