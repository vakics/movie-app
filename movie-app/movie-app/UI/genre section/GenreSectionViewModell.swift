//
//  GenreSectionViewModell.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 29..
//
import Foundation
import InjectPropertyWrapper
import Combine

protocol GenreSectionViewModel: ObservableObject {
    func loadGenres()
    func genreAppeared()
    func loadMotdMovie()
}

class GenreSectionViewModelImp: GenreSectionViewModel, ErrorPrentable {
    private var cancellables = Set<AnyCancellable>()
    @Published var genres: [Genre] = []
    @Published var alertModel: AlertModel? = nil
    @Published var mediaItemsByGenre: [Int: [MediaItem]] = [:]
    @Published var motdMovie: MediaItemDetail?
    @Inject
    private var useCase: GenreSectionUseCase
    let typeSubject = CurrentValueSubject<MediaItemType, Never>(.movie)
    
    func loadGenres() {
        useCase.loadGenres(typeSubject: typeSubject)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] genres in
                self?.genres = genres
            }
            .store(in: &cancellables)
    }
    
    func genreAppeared() {
        useCase.genresAppeared()
    }
    
    init() {
        useCase.showAppearPopup
                    .compactMap { showAppearPopup -> AlertModel? in
                        if showAppearPopup {
                            return AlertModel(title: "[[Értékeld az appot]]", message: "[[Értékeld az appot]]", dismissButtonTitle: "[[Rendben]]")
                        }
                        return nil
                    }
                    .sink { [weak self]alertModel in
                        self?.alertModel = alertModel
                    }
                    .store(in: &cancellables)
    }
    func loadMediaItems(genreId: Int, typeSubject: CurrentValueSubject<MediaItemType, Never>){
        useCase.loadMediaItems(genreId: genreId, typeSubject: typeSubject)
            .delay(for: .seconds(1), scheduler: RunLoop.main)
            .sink{ completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { mediaItems in
                self.mediaItemsByGenre[genreId] = mediaItems
            }
            .store(in: &cancellables)
    }
    
    func loadMotdMovie() {
        useCase.loadMotdMovie(type: typeSubject.value)
            .sink { completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { movie in
                self.motdMovie = movie
            }
            .store(in: &cancellables)
    }
    
    func getMediaItemsByGenre(_ genreId: Int) -> [MediaItem]{
        return self.mediaItemsByGenre[genreId] ?? [MediaItem(),MediaItem(id: -2),MediaItem(id: -3)]
    }
    
}
