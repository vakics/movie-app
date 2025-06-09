//
//  SearchViewModel.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 26..
//

import Foundation
import Combine
import InjectPropertyWrapper

protocol SearchViewModelProtocol: ObservableObject {
    var movies: [MediaItem] { get }
    var searchText: String { get set }
}

class SearchViewModel: SearchViewModelProtocol, ErrorPrentable {
    @Published var movies: [MediaItem] = []
    @Published var searchText: String = ""
    @Published var alertModel: AlertModel? = nil
    private var cancellables = Set<AnyCancellable>()
        
        let startSearch = PassthroughSubject<Void, Never>()
    
    @Inject
    private var repository: MovieRepository
    
    init() {
        startSearch
            .print("<<< startSearch")
            .debounce(for: .seconds(2.5), scheduler: RunLoop.main)
            .flatMap { [weak self]_ ->  AnyPublisher<[MediaItem], MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = SearchMoviesRequest(query: self.searchText)
                return self.repository.searchMovies(req: request)
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
