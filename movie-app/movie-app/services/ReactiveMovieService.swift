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

protocol ReactiveMoviesServiceProtocol {
    func fetchGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError>
    func fetchTVGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError>
    func searchMovies(req: SearchMoviesRequest) -> AnyPublisher<[MediaItem], MovieError>
    func fetchMovies(req: FetchMoviesRequest) -> AnyPublisher<[MediaItem], MovieError>
    func fetchTVShows(req: FetchMoviesRequest) -> AnyPublisher<[MediaItem], MovieError>
}

class ReactiveMoviesService: ReactiveMoviesServiceProtocol {
    @Inject
    var moya: MoyaProvider<MultiTarget>!
    
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
                case .failure:
                    promise(.failure(.unexpectedError))
                }
            }
        }
        return future
            .eraseToAnyPublisher()
    }
}
