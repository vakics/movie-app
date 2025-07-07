//
//  DetailViewModel.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 08..
//
import Foundation
import Combine
import InjectPropertyWrapper

protocol DetailViewModelProtocol: ObservableObject {
}

class DetailViewModel: DetailViewModelProtocol, ErrorPrentable {
    @Published var mediaItemDetail: MediaItemDetail = MediaItemDetail()
    @Published var credits: [CastMember] = []
    @Published var isFavorite: Bool = false
    @Published var alertModel: AlertModel? = nil
    @Published var similarItems: [MediaItem] = []
    @Published var isLoading: Bool = true
    var pageNumber: Int = 1
    
    let mediaItemSubject = PassthroughSubject<MediaItem, Never>()
    let favoriteButtonTapped = PassthroughSubject<Void, Never>()
    let reachedEndSubject = PassthroughSubject<Void, Never>()
    let typeSubject = CurrentValueSubject<MediaItemType, Never>(.movie)
    
    @Inject
    private var repository: MovieRepository
    
    @Inject
    private var mediaItemStore: MediaItemStoreProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        let initialLoad = mediaItemSubject
            .flatMap { [weak self] mediaItem -> AnyPublisher<(MediaItemDetail, [CastMember], [MediaItem]), MovieError> in
                guard let self = self else {
                    return Fail(error: .unexpectedError)
                        .eraseToAnyPublisher()
                }

                let request = FetchDetailRequest(mediaId: mediaItem.id)

                let detailPublisher: AnyPublisher<MediaItemDetail, MovieError> = {
                    switch mediaItem.showType {
                    case .movie:
                        return self.repository.fetchMovieDetail(req: request)
                    case .tvShow:
                        return self.repository.fetchTVDetail(req: request)
                    case .unknown:
                        return Just(MediaItemDetail())
                            .setFailureType(to: MovieError.self)
                            .eraseToAnyPublisher()
                    }
                }()

                let creditsPublisher: AnyPublisher<[CastMember], MovieError> = {
                    if mediaItem.showType == .movie {
                        let creditsRequest = FetchMovieCreditsRequest(mediaId: mediaItem.id)
                        return self.repository.fetchMovieCredits(req: creditsRequest)
                    }
                    return Just([])
                        .setFailureType(to: MovieError.self)
                        .eraseToAnyPublisher()
                }()

                let similarPublisher = self.fetchSimilarMovies(for: mediaItem, page: 1)

                return Publishers.CombineLatest3(detailPublisher, creditsPublisher, similarPublisher)
                    .eraseToAnyPublisher()
            }
        initialLoad
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                    self?.isLoading = false
                }
            }, receiveValue: { [weak self] detail, credits, similars in
                guard let self = self else { return }
                self.mediaItemDetail = detail
                self.credits = credits
                self.similarItems = similars
                self.isFavorite = self.mediaItemStore.isMediaItemStored(withId: detail.id)
                self.pageNumber += 1
                self.isLoading = false
            })
            .store(in: &cancellables)
        reachedEndSubject
            .flatMap { [weak self] mediaItem -> AnyPublisher<[MediaItem], MovieError> in
                guard let self = self else {
                    return Fail(error: .unexpectedError).eraseToAnyPublisher()
                }
                self.isLoading = true
                return self.fetchSimilarMovies(for: MediaItem(detail: mediaItemDetail), page: self.pageNumber)
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                    self?.isLoading = false
                }
            }, receiveValue: { [weak self] newItems in
                guard let self = self else { return }

                if !newItems.isEmpty {
                    self.similarItems.append(contentsOf: newItems)
                    self.pageNumber += 1
                }
                self.isLoading = false
            })
            .store(in: &cancellables)
        
        favoriteButtonTapped
            .flatMap { [weak self] _ -> AnyPublisher<(ModifyMediaResult, Bool), MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let isFavorite = !self.isFavorite
                let request = EditFavoriteRequest(movieId: self.mediaItemDetail.id, isFavorite: isFavorite)
                return repository.editFavoriteMovie(req: request)
                    .map { result in
                        (result, isFavorite)
                    }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] result, isFavorite in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                if result.success {
                    self.isFavorite = isFavorite
                    if isFavorite {
                        self.mediaItemStore.saveMediaItems([MediaItem(detail: self.mediaItemDetail)])
                    } else {
                        self.mediaItemStore.deleteMediaItem(withId: self.mediaItemDetail.id)
                    }
                }
            }
            .store(in: &cancellables)
    }
    private func fetchSimilarMovies(for mediaItem: MediaItem, page: Int) -> AnyPublisher<[MediaItem], MovieError> {
        guard mediaItem.showType == .movie else {
            return Just([])
                .setFailureType(to: MovieError.self)
                .eraseToAnyPublisher()
        }

        let request = FetchSimilarMovie(movieId: mediaItem.id, pageNumber: page)
        return repository.fetchSimilarMovies(req: request)
            .map { $0.mediaItems }
            .eraseToAnyPublisher()
    }
}
