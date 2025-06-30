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

protocol MovieRepository {
    func fetchGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError>
    func fetchTVGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError>
    func searchMovies(req: SearchMoviesRequest) -> AnyPublisher<[MediaItem], MovieError>
    func fetchMovies(req: FetchMoviesRequest) -> AnyPublisher<MediaItemPage, MovieError>
    func fetchTVShows(req: FetchMoviesRequest) -> AnyPublisher<MediaItemPage, MovieError>
    func fetchMovieDetail(req: FetchDetailRequest) -> AnyPublisher<MediaItemDetail, MovieError>
    func fetchTVDetail(req: FetchDetailRequest) -> AnyPublisher<MediaItemDetail, MovieError>
    func fetchMovieCredits(req: FetchMovieCreditsRequest) -> AnyPublisher<[CastMember], MovieError>
    func fetchFavoriteMovies(req: FetchFavoriteMovieRequest, fromLocal: Bool) -> AnyPublisher<[MediaItem], MovieError>
    func editFavoriteMovie(req: EditFavoriteRequest) -> AnyPublisher<ModifyMediaResult, MovieError>
    func addReview(req: AddReviewRequest)->AnyPublisher<ModifyMediaResult, MovieError>
    func fetchCastMemberDetail(req: FetchCastMemberDetailRequest)->AnyPublisher<CastDetail, MovieError>
    func fetchCompanyDetail(req: FetchCastMemberDetailRequest)->AnyPublisher<CastDetail, MovieError>
    func fetchSimilarMovies(req: FetchSimilarMovie)->AnyPublisher<MediaItemPage, MovieError>
    func fetchCombinedCredits(req: FetchCastMemberDetailRequest)->AnyPublisher<[CombinedMediaItem], MovieError>
    func fetchRandomMovies(req: FetchRandomMediaItems)->AnyPublisher<[MediaItem], MovieError>
    func fetchRandomTvShows(req: FetchRandomMediaItems)->AnyPublisher<[MediaItem], MovieError>
}

class MovieRepositoryImp: MovieRepository {
    @Inject
    var moya: MoyaProvider<MultiTarget>!
    @Inject
    private var store: MediaItemStoreProtocol
    @Inject
    private var detailStore: MediaItemDetailStoreProtocol
    @Inject
    private var castMemberStore: CastMemberStoreProtocol
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
    
    func fetchMovies(req: FetchMoviesRequest) -> AnyPublisher<MediaItemPage, MovieError> {
        requestAndTransform(target: MultiTarget(MoviesApi.fetchMovies(req: req)), decodeTo: MoviePageResponse.self, transform: { MediaItemPage.init(dto: $0) })
    }
    
    func fetchTVShows(req: FetchMoviesRequest) -> AnyPublisher<MediaItemPage, MovieError> {
        requestAndTransform(target: MultiTarget(MoviesApi.fetchTVShows(req: req)), decodeTo: TVPageResponse.self, transform: {MediaItemPage.init(dto: $0)})
    }
    
    func fetchMovieDetail(req: FetchDetailRequest) -> AnyPublisher<MediaItemDetail, MovieError> {
        let serviceResponse: AnyPublisher<MediaItemDetail, MovieError> = self.requestAndTransform(
            target: MultiTarget(MoviesApi.fetchMovieDetail(req: req)),
            decodeTo: MovieDetailResponse.self,
            transform: { MediaItemDetail.init(dto: $0) }
        )
            .handleEvents(receiveOutput: { [weak self]mediaItemDetail in
                self?.detailStore.saveMediaItemDetail(mediaItemDetail)
            })
            .eraseToAnyPublisher()
        
        let localResponse: AnyPublisher<MediaItemDetail, MovieError> = detailStore.getMediaItemDetail(withId: req.mediaId)
        
        return networkMonitor.isConnected
            .flatMap { isConnected -> AnyPublisher<MediaItemDetail, MovieError> in
                if isConnected {
                    return serviceResponse
                } else {
                    return localResponse
                }
            }
            .eraseToAnyPublisher()
    }
    func fetchTVDetail(req: FetchDetailRequest) -> AnyPublisher<MediaItemDetail, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchTVDetail(req: req)),
            decodeTo: TVDetailResponse.self,
            transform: { MediaItemDetail.init(dto: $0) }
        )

    }
    
    func fetchMovieCredits(req: FetchMovieCreditsRequest) -> AnyPublisher<[CastMember], MovieError> {
        return networkMonitor.isConnected
            .flatMap { isConnected -> AnyPublisher<[CastMember], MovieError> in
                if isConnected {
                    return self.requestAndTransform(
                        target: MultiTarget(MoviesApi.fetchMovieCredits(req: req)),
                        decodeTo: MovieCreditsResponse.self,
                        transform: { dto in
                            dto.cast.map(CastMember.init(dto:))
                        }
                    )
                    .handleEvents(receiveOutput: { [weak self]castMembers in
                        self?.castMemberStore.saveCastMembers(castMembers, forMovieId: req.mediaId)
                    })
                    .eraseToAnyPublisher()
                } else {
                    return self.castMemberStore.getCastMembers(fromMovieId: req.mediaId)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchFavoriteMovies(req: FetchFavoriteMovieRequest, fromLocal: Bool = false) -> AnyPublisher<[MediaItem], MovieError> {
        let serviceResponse: AnyPublisher<[MediaItem], MovieError> = self.requestAndTransform(
            target: MultiTarget(MoviesApi.fetchFavoriteMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { $0.results.map(MediaItem.init(dto:)) }
        )
            .handleEvents(receiveOutput: { [weak self]mediaItems in
                self?.store.saveMediaItems(mediaItems)
            })
            .eraseToAnyPublisher()
        
        let localResponse: AnyPublisher<[MediaItem], MovieError> = store.mediaItems
        
        return networkMonitor.isConnected
            .flatMap { isConnected -> AnyPublisher<[MediaItem], MovieError> in
                if isConnected {
                    return serviceResponse
                } else {
                    return localResponse
                }
            }
            .eraseToAnyPublisher()
    }
    
    func editFavoriteMovie(req: EditFavoriteRequest) -> AnyPublisher<ModifyMediaResult, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.editFavoriteMovie(req: req)),
            decodeTo: ModifyMediaRequest.self,
            transform: { response in
                ModifyMediaResult(dto: response)
            }
        )
    }
    
    func addReview(req: AddReviewRequest) -> AnyPublisher<ModifyMediaResult, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.addReview(req: req)),
            decodeTo: ModifyMediaRequest.self,
            transform: {response in
                ModifyMediaResult(dto: response)
            })
    }
    
    func fetchCastMemberDetail(req: FetchCastMemberDetailRequest) -> AnyPublisher<CastDetail, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchCastMemberDetail(req: req)),
            decodeTo: CastMemberDetailResponse.self,
            transform: {response in
                CastDetail(dto: response)})
    }
    
    func fetchCompanyDetail(req: FetchCastMemberDetailRequest) -> AnyPublisher<CastDetail, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchCompanyDetail(req: req)),
            decodeTo: CompanyDetailResponse.self,
            transform: {response in
                CastDetail(dto: response)})
    }
    
    func fetchSimilarMovies(req: FetchSimilarMovie) -> AnyPublisher<MediaItemPage, MovieError> {
        requestAndTransform(target: MultiTarget(MoviesApi.fetchSimilarMovies(req: req)), decodeTo: MoviePageResponse.self, transform: {response in
            MediaItemPage(dto: response)
        })
    }
    
    func fetchCombinedCredits(req: FetchCastMemberDetailRequest) -> AnyPublisher<[CombinedMediaItem], MovieError> {
        requestAndTransform(target: MultiTarget(MoviesApi.fetchCombinedCredits(req: req)), decodeTo: CombinedMediaItemCastResponse.self, transform: {
            $0.cast.map(CombinedMediaItem.init(dto:))
        })
    }
    
    func fetchRandomMovies(req: FetchRandomMediaItems) -> AnyPublisher<[MediaItem], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchRandomMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { $0.results.map(MediaItem.init(dto:)) }
        )
    }
    
    func fetchRandomTvShows(req: FetchRandomMediaItems) -> AnyPublisher<[MediaItem], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchRandomTvShows(req: req)),
            decodeTo: TVPageResponse.self,
            transform: { $0.results.map(MediaItem.init(dto:)) }
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
                    case 500..<600:
                        promise(.failure(.serverError))
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
