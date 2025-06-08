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
    
    let mediaItemIdSubject = CurrentValueSubject<Int?, Never>(nil)
    let favoriteButtonTapped = PassthroughSubject<Void, Never>()
    
    @Inject
    private var repository: MovieRepository
    
    @Inject
    private var mediaItemStore: MediaItemStoreProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
        let details = mediaItemIdSubject
            .compactMap { $0 }
            .flatMap { [weak self]mediaItemId in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchDetailRequest(mediaId: mediaItemId)
                return self.repository.fetchMovieDetail(req: request)
            }
        
        let credits = mediaItemIdSubject
            .compactMap { $0 }
            .flatMap { [weak self]mediaItemId in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchMovieCreditsRequest(mediaId: mediaItemId)
                return self.repository.fetchMovieCredits(req: request)
            }
        
        Publishers.CombineLatest(details, credits)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] details, credits in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                print("<<<DEBUG - Loaded detail id: \(details.id)")
                self.mediaItemDetail = details
                self.credits = credits
                self.isFavorite = self.mediaItemStore.isMediaItemStored(withId: details.id)
            }
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
    
}
