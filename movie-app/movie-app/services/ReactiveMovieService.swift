//
//  ReactiveMovieService.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 06..
//

import Foundation
import Moya
import InjectPropertyWrapper
import Combine
import Alamofire

protocol ReactiveMoviesServiceProtocol {
    func fetchGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError>
    func fetchTVGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError>
    func searchMovies(req: SearchMoviesRequest) -> AnyPublisher<[MediaItem], MovieError>
    func fetchMovies(req: FetchMoviesRequest) -> AnyPublisher<[MediaItem], MovieError>
    func fetchTVShows(req: FetchMoviesRequest) -> AnyPublisher<[MediaItem], MovieError>
    func fetchMovieDetail(req: FetchDetailRequest) -> AnyPublisher<MediaItemDetail, MovieError>
    func fetchMovieCredits(req: FetchMovieCreditsRequest) -> AnyPublisher<[CastMember], MovieError>
    func fetchFavoriteMovies(req: FetchFavoriteMovieRequest, fromLocal: Bool) -> AnyPublisher<[MediaItem], MovieError>
    func editFavoriteMovie(req: EditFavoriteRequest) -> AnyPublisher<EditFavoriteResult, MovieError>
}

class ReactiveMoviesService: ReactiveMoviesServiceProtocol {
    @Inject
    var moya: MoyaProvider<MultiTarget>!
    @Inject
    private var store: MediaItemStoreProtocol
    @Inject
    private var networkMonitor: NetworkMonitorProtocol
    
    func fetchGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchGenres(req: req)),
            decodeTo: GenreListResponse.self,
            transform: { $0.genres.map(Genre.init(dto:)) }
        )
    }
    
    func fetchTVGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchTVGenres(req: req)),
            decodeTo: GenreListResponse.self,
            transform: { $0.genres.map(Genre.init(dto:)) }
        )
    }
    
    func searchMovies(req: SearchMoviesRequest) -> AnyPublisher<[MediaItem], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.searchMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { $0.results.map(MediaItem.init(dto:)) }
        )
    }
    
    func fetchMovies(req: FetchMoviesRequest) -> AnyPublisher<[MediaItem], MovieError> {
        requestAndTransform(target: MultiTarget(MoviesApi.fetchMovies(req: req)), decodeTo: MoviePageResponse.self, transform: { $0.results.map(MediaItem.init(dto:)) })
    }
    
    func fetchTVShows(req: FetchMoviesRequest) -> AnyPublisher<[MediaItem], MovieError> {
        requestAndTransform(target: MultiTarget(MoviesApi.fetchTVShows(req: req)), decodeTo: TVPageResponse.self, transform: {$0.results.map(MediaItem.init(dto:))})
    }
    
    func fetchMovieDetail(req: FetchDetailRequest) -> AnyPublisher<MediaItemDetail, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchMovieDetail(req: req)),
            decodeTo: MovieDetailResponse.self,
            transform: { MediaItemDetail(dto: $0) }
        )
    }
    
    func fetchMovieCredits(req: FetchMovieCreditsRequest) -> AnyPublisher<[CastMember], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchMovieCredits(req: req)),
            decodeTo: MovieCreditsResponse.self,
            transform: { dto in
                dto.cast.map(CastMember.init(dto:))
            }
        )
    }
    
    func fetchFavoriteMovies(req: FetchFavoriteMovieRequest, fromLocal: Bool = false) -> AnyPublisher<[MediaItem], MovieError> {
        networkMonitor.isConnected.flatMap{ isConnected in
            if isConnected || !fromLocal {
                self.requestAndTransform(
                    target: MultiTarget(MoviesApi.fetchFavoriteMovies(req: req)),
                    decodeTo: MoviePageResponse.self,
                    transform: { $0.results.map(MediaItem.init(dto:)) }
                ).handleEvents(receiveOutput: {[weak self]mediaItems in
                    self?.store.saveMediaItems(mediaItems)
                })
                .eraseToAnyPublisher()
            } else{
                self.store.mediaItems
            }
        }.eraseToAnyPublisher()
    }
    
    func editFavoriteMovie(req: EditFavoriteRequest) -> AnyPublisher<EditFavoriteResult, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.editFavoriteMovie(req: req)),
            decodeTo: EditFavoriteResponse.self,
            transform: { response in
                EditFavoriteResult(dto: response)
            }
        )
    }
    
    private func requestAndTransform<ResponseType: Decodable, Output>(
        target: MultiTarget,
        decodeTo: ResponseType.Type,
        transform: @escaping (ResponseType) -> Output
    ) -> AnyPublisher<Output, MovieError> {
        let future = Future<Output, MovieError> { promise in
            self.moya.request(target) { result in
                switch result {
                case .success(let response):
                    switch response.statusCode {
                    case 200..<300:
                        do {
                            let decoded = try JSONDecoder().decode(decodeTo, from: response.data)
                            let output = transform(decoded)
                            promise(.success(output))
                        } catch {
                            promise(.failure(.unexpectedError))
                        }
                    case 400..<500:
                        promise(.failure(.clientError))
                    default:
                        if let apiError = try? JSONDecoder().decode(MovieAPIErrorResponse.self, from: response.data) {
                            if apiError.statusCode == 7 {
                                promise(.failure(.invalidApiKeyError(message: apiError.statusMessage)))
                            } else {
                                promise(.failure(.unexpectedError))
                            }
                        } else {
                            promise(.failure(.unexpectedError))
                        }
                    }
                case .failure(let error):
                    if error.isNoInternetError{
                        promise(.failure(MovieError.noInternetError))
                    } else {
                        promise(.failure(.unexpectedError))
                    }
                }
            }
        }
        return future
            .eraseToAnyPublisher()
    }
}

extension MoyaError {
    var isNoInternetError: Bool {
        if case let .underlying(error, _) = self {
            // Ha AFError
            if let afError = error as? AFError {
                if let urlError = afError.underlyingError as? URLError {
                    return urlError.code == .notConnectedToInternet
                } else if let nsError = afError.underlyingError as NSError? {
                    return nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorNotConnectedToInternet
                }
            }
        }
        return false
    }
}
