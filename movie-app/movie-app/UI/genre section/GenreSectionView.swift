//
//  ContentView.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 06..
//

import SwiftUI

class GenreSectionViewModel: ObservableObject {
    @Published var genres: [Genre] = []
    private var movieService: MovieService = MovieService()
    
    func fetchGenres() async {
        do {
            let request = FetchGenreRequest()
            let genres = try await movieService.fetchGenres(req: request)
            DispatchQueue.main.async {
                self.genres = genres
            }
        } catch {
            print("Error fetching genres")
        }
        
//        self.genres = [
//            Genre(id: 1, name: "Adventure"),
//            Genre(id: 2, name: "Sci-fi"),
//            Genre(id: 3, name: "Fantasy"),
//            Genre(id: 4, name: "Comedy")
//        ]
    }
    func fetchTVGenres() async {
        do {
            let request = FetchGenreRequest()
            let genres = try await movieService.fetchTVGenres(req: request)
            DispatchQueue.main.async {
                self.genres = genres
            }
        } catch {
            print("Error fetching Tv genres")
        }
    }
    
    func load(type: GenreType) async {
//        return await Environment.name == .tv ? fetchTVGenres() : fetchGenres()
        switch type {
        case .movie:
            return await fetchGenres()
        case .tvShow:
            return await fetchTVGenres()
        }
    }
}

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
                        NavigationLink(destination: Color.gray) {
                            EmptyView()
                        }.opacity(0)

                    HStack {
                        Text(genre.name).font(Fonts.title)
                            .foregroundStyle(.primary)
                        Spacer()
                        Image(.rightArrow)
                        }
                                        
                    }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                .listStyle(.plain)
                .navigationTitle(Environment.name == .dev ? "DEV" : "PROD")
            }
            .onAppear {
//                a task felel a háttérben futó hívásokért
                Task {
                    await viewModel.load(type: type)
                }
            }
        }
    }
}

#Preview {
    GenreSectionView(type: .movie)
}
