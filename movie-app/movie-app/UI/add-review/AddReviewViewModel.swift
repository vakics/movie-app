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
    @Published var success: Bool = false
    @Published var alertModel: AlertModel? = nil
    
    @Inject
    var repository: MovieRepository
    
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
                let rating: Double = Double(self.selectedRating + 1)
                let request = AddReviewRequest(mediaId: mediaItemDetail.id, rating: rating)
                return self.repository.addReview(req: request)
            }
            .sink(receiveCompletion: {completion in
                switch completion{
                case .failure(let error):
                    self.alertModel = self.toAlertModel(error)
                case .finished:
                    break
                }
            }, receiveValue: {[weak self]result in
                print(result)
                self?.success = true
            }).store(in: &cancellables)
    }
}
