//
//  GenreSectionUseCase.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 27..
//

import Combine
import InjectPropertyWrapper

protocol GenreSectionUseCase{
    var showAppearPopup: AnyPublisher<Bool, Never> {get}
    func loadGenres(typeSubject: CurrentValueSubject<MediaItemType, Never>) -> AnyPublisher<[Genre], MovieError>
    func genresAppeared()
    func getType(typeSubject: CurrentValueSubject<MediaItemType, Never>) -> MediaItemType
    func loadMediaItems(genreId: Int, typeSubject: CurrentValueSubject<MediaItemType, Never>) -> AnyPublisher<[MediaItem], MovieError>
    func loadMotdMovie(type: MediaItemType) -> AnyPublisher<MediaItemDetail, MovieError>
}

class GenreSectionUseCaseImp: GenreSectionUseCase{
    
    @Inject
    private var repository: MovieRepository
    private var apperCounter = 0
    private var appearSubject = CurrentValueSubject<Int, Never>(0)
    var actualPage: Int = 1
    
    var showAppearPopup: AnyPublisher<Bool, Never>{
        appearSubject.map {
            counter in
            counter == 3
        }
        .eraseToAnyPublisher()
    }
    
    func getType(typeSubject: CurrentValueSubject<MediaItemType, Never>) -> MediaItemType {
        return typeSubject.value
    }
    
    func loadGenres(typeSubject: CurrentValueSubject<MediaItemType, Never>) -> AnyPublisher<[Genre], MovieError> {
        let type = getType(typeSubject: typeSubject)
        let request = FetchGenreRequest()
        let genres = switch type {
        case .movie:
            self.repository.fetchGenres(req: request)
        case .tvShow:
            self.repository.fetchTVGenres(req: request)
        case .unknown:
            Just<[Genre]>([])
                .setFailureType(to: MovieError.self)
                .eraseToAnyPublisher()
        }
        return genres
            .handleEvents(receiveOutput: {genres in
                print(genres.count)
            })
            .eraseToAnyPublisher()
    }
    func genresAppeared() {
        apperCounter += 1
        appearSubject.send(apperCounter)
    }
    func loadMediaItems(genreId: Int, typeSubject: CurrentValueSubject<MediaItemType, Never>) -> AnyPublisher<[MediaItem], MovieError> {
        let request = FetchMoviesRequest(genreId: genreId, pageNumber: actualPage)
        let mediaItemPages = getType(typeSubject: typeSubject) == .tvShow ? self.repository.fetchTVShows(req: request) : self.repository.fetchMovies(req: request)
        return mediaItemPages.map({ page in
            Array(page.mediaItems.prefix(upTo: 5))
        }).eraseToAnyPublisher()
    }
    
    func loadMotdMovie(type: MediaItemType) -> AnyPublisher<MediaItemDetail, MovieError> {
        loadRandomMediaItems(type: type)
            .compactMap{$0.randomElement()}
            .flatMap { randomItem in
                let request = FetchDetailRequest(mediaId: randomItem.id)
                return type == .tvShow ? self.repository.fetchTVDetail(req: request) : self.repository.fetchMovieDetail(req: request)
            }
            .eraseToAnyPublisher()
        
    }
    
    func loadRandomMediaItems(type: MediaItemType) -> AnyPublisher<[MediaItem], MovieError>{
        let request = FetchRandomMediaItems()
        return type == .tvShow ? self.repository.fetchRandomTvShows(req: request) : self.repository.fetchRandomMovies(req: request)
    }
}


