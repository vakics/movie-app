//
//  AddReviewViewModel.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 23..
//


import Foundation
import InjectPropertyWrapper
import Combine

class AddReviewViewModel: ObservableObject, ErrorPrentable {
    @Published var mediaItemDetail: MediaItemDetail = MediaItemDetail()
    @Published var selectedRating: Int = -1
    
    @Inject
    var service: ReactiveMoviesServiceProtocol
    
    let mediaDetailSubject = PassthroughSubject<MediaItemDetail, Never>()
    let ratingBtnSubject = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        mediaDetailSubject
            .sink { [weak self]detail in
                self?.mediaItemDetail = detail
            }
            .store(in: &cancellables)
        ratingBtnSubject
            .flatMap{ [weak self] _->AnyPublisher<ModifyMediaResult, MovieError> in
                guard let self = self else{
                    preconditionFailure("there is no self")
                }
                let rating: Double = Double(self.selectedRating)
                let request = AddReviewRequest(mediaId: mediaItemDetail.id, rating: rating)
                return self.service.addReview(req: request)
            }
            .sink(receiveCompletion: {_ in
                    
            }, receiveValue: {result in
                
            }).store(in: &cancellables)
    }
}
