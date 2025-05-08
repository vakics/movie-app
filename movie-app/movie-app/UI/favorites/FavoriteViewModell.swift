//
//  FavoriteViewModell.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 04..
//

import Foundation
import Combine
import InjectPropertyWrapper

protocol FavoriteViewModellProtocol: ObservableObject{
    var movies: [MediaItem] {get}
}

class FavoriteViewModell: FavoriteViewModellProtocol, ErrorPrentable{
    @Published var alertModel: AlertModel? = nil
    @Published var movies: [MediaItem] = []
    private var cancellables = Set<AnyCancellable>()
    @Inject
    private var movieService: MovieServiceProtocol
    init() {
        let request = FetchFavoriteMovieRequest()
        let future = Future<[MediaItem], Error> { promise in
            Task {
                do {
                    let movies = try await self.movieService.fetchFavoriteMovies(req: request)
                    promise(.success(movies))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        
        future
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertModel = self.toAlertModel(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies
            }
            .store(in: &cancellables)
    }
    
}
