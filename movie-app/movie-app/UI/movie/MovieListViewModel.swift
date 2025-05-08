//
//  MovieListViewModel.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 08..
//
import InjectPropertyWrapper
import Combine

protocol MovieListViewModelProtocol: ObservableObject{
    
}

class MovieListViewModel: MovieListViewModelProtocol, ErrorPrentable {
    @Published var movies: [MediaItem] = []
    @Published var alertModel: AlertModel? = nil
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    let genreIdSubject = PassthroughSubject<Int, Never>()
    let typeSubject = PassthroughSubject<GenreType, Never>()
    private var cancellables = Set<AnyCancellable>()
    init() {
        Publishers.CombineLatest(typeSubject, genreIdSubject)
            .flatMap { [weak self] (type, genreId) -> AnyPublisher<[MediaItem], MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchMoviesRequest(genreId: genreId)
                switch type {
                case .movie:
                    return self.service.fetchMovies(req: request)
                case .tvShow:
                    return self.service.fetchTVShows(req: request)
                }
            }
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies
            }
            .store(in: &cancellables)
    }
}
