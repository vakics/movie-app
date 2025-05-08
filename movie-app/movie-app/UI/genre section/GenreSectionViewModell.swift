//
//  GenreSectionViewModell.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 29..
//
import Foundation
import InjectPropertyWrapper
import Combine

protocol GenreSectionViewModelProtocol: ObservableObject {
    
}

class GenreSectionViewModel: GenreSectionViewModelProtocol, ErrorPrentable {
    private var cancellables = Set<AnyCancellable>()
    @Published var genres: [Genre] = []
    @Published var alertModel: AlertModel? = nil
    
    @Inject
    private var movieService: ReactiveMoviesServiceProtocol
    let typeSubject = PassthroughSubject<GenreType, Never>()
    
    init() {
        typeSubject
            .flatMap { [weak self] type -> AnyPublisher<[Genre], MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchGenreRequest()
                switch type {
                case .movie:
                    return self.movieService.fetchGenres(req: request)
                case .tvShow:
                    return self.movieService.fetchTVGenres(req: request)
                }
            }
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] genres in
                self?.genres = genres
            }
            .store(in: &cancellables)
    }
    
    //    init() {
    //            let request = FetchGenreRequest()
    //            let future = Future<[Genre], Error> { promise in
    //                Task {
    //                    do {
    //                        let genres = try await self.movieService.fetchGenres(req: request)
    //                        promise(.success(genres))
    //                    } catch {
    //                        promise(.failure(error))
    //                    }
    //                }
    //            }
    //
    //            future
    //                .receive(on: RunLoop.main)
    //                .sink { completion in
    //                    if case let .failure(error) = completion {
    //                        self.alertModel = self.toAlertModel(error)
    //                    }
    //                } receiveValue: { [weak self]genres in
    //                    self?.genres = genres
    //                }
    //                .store(in: &cancellables)
    //        }
    ////    init() {
    //            let request = FetchGenreRequest()
    //
    //            let publisher = PassthroughSubject<[Genre], Error>()
    //
    //            Task {
    //                do {
    //                    let genres = try await self.movieService.fetchTVGenres(req: request)
    //                    publisher.send(genres)
    //                    publisher.send(completion: .finished) // FONTOS: befejezés
    //                } catch {
    //                    publisher.send(completion: .failure(error)) // Hiba küldése
    //                }
    //            }
    //
    //            publisher
    //                .receive(on: RunLoop.main)
    //                .sink { completion in
    //                    if case let .failure(error) = completion {
    //                        self.alertModel = self.toAlertModel(error)
    //                    }
    //                } receiveValue: { genres in
    //                    self.genres = genres
    //                }
    //                .store(in: &cancellables)
    //        }
}
