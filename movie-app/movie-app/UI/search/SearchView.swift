//
//  SearchView.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 17..
//

import SwiftUI
import InjectPropertyWrapper

protocol SearchViewModelProtocol: ObservableObject{
    
}

class SearchViewModel: SearchViewModelProtocol {
    @Published var movies: [Movie] = []
    
    @Inject
    private var service: MovieServiceProtocol
    
    func searchMovies(by searchTerm: String) async {
        do {
            let request = SearchMoviesRequest(query: searchTerm)
            let movies = try await service.searchMovies(req: request)
            DispatchQueue.main.async {
                self.movies = movies
            }
        } catch {
            print("Error searching movies: \(error)")
        }
    }
}

struct SearchView: View {
    var movieTitle: String
    @StateObject private var viewModel = SearchViewModel()
    let columns = [
        GridItem(.flexible(), spacing: 16)
    ]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 24) {
                ForEach(viewModel.movies) { movie in
                    MovieCellView(movie: movie)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }.modifier(EmptyModifier(isEmpty: movieTitle==""))
            .onChange(of: movieTitle){
                Task{
                    await viewModel.searchMovies(by: movieTitle)
                }
            }
    }
}

#Preview {
    SearchView(movieTitle: "m")
}
