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
    var mediaItems: [MediaItem] {get}
}

class FavoriteViewModell: FavoriteViewModellProtocol, ErrorPrentable{
    @Published var mediaItems: [MediaItem] = []
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    let viewLoaded = PassthroughSubject<Void, Never>()
    
    @Inject
    private var service: MovieRepository
    
    init() {
        viewLoaded
            .flatMap { [weak self]_ -> AnyPublisher<[MediaItem], MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                return self.service.fetchFavoriteMovies(req: FetchFavoriteMovieRequest(), fromLocal: false)
            }
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertModel = self.toAlertModel(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self]mediaItems in
                self?.mediaItems = mediaItems
            }
            .store(in: &cancellables)
        
    }
}
