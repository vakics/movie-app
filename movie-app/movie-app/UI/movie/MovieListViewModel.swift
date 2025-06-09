//
//  MovieListViewModel.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 08..
//
import InjectPropertyWrapper
import Combine
import Foundation

protocol MovieListViewModelProtocol: ObservableObject{
    
}

class MovieListViewModel: MovieListViewModelProtocol, ErrorPrentable {
    @Published var movies: [MediaItem] = []
    @Published var alertModel: AlertModel? = nil
    @Inject
    private var repository: MovieRepository
    @Published var actualPage: Int = 1
    var totalPages: Int = Int.max
    @Published var isLoading: Bool = false
    
    let genreIdSubject = PassthroughSubject<Int, Never>()
    let typeSubject = PassthroughSubject<GenreType, Never>()
    let reachedBottomSubject = CurrentValueSubject<Void, Never>(())
    private var cancellables = Set<AnyCancellable>()
    init() {
        Publishers.CombineLatest3(typeSubject, genreIdSubject, reachedBottomSubject)
            .filter { [weak self]_ in
                            guard let self = self else {
                                preconditionFailure("There is no self")
                            }
                return self.actualPage < self.totalPages
                        }
            .handleEvents(receiveOutput: { [weak self]_ in
                            guard let self = self else {
                                preconditionFailure("There is no self")
                            }
                            self.isLoading = true
                        })
            .flatMap { [weak self] (type, genreId, _) -> AnyPublisher<MediaItemPage, MovieError> in
                self?.isLoading = true
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchMoviesRequest(genreId: genreId, pageNumber: actualPage)
                switch type {
                case .movie:
                    return self.repository.fetchMovies(req: request)
                case .tvShow:
                    return self.repository.fetchTVShows(req: request)
                }
            }
            .delay(for: .seconds(2), scheduler: RunLoop.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                    self?.isLoading = false
                }
            } receiveValue: { [weak self] page in
                self?.movies.append(contentsOf: page.mediaItems)
                self?.actualPage += 1
                self?.totalPages = page.totalPages
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
}
