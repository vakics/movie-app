//
//  PersonDetailViewModel.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 06. 14..
//


import Foundation
import Combine
import InjectPropertyWrapper

enum CastDetailType{
    var id: Int{
        switch self{
        case .castMember(id: let id):
            return id
        case .company(id: let id):
            return id
        }
    }
    case castMember(id: Int)
    case company(id:Int)
    
}

class CastDetailViewModel: ObservableObject, ErrorPrentable {
    @Published var castDetail: CastDetail?
    @Published var alertModel: AlertModel? = nil
    @Published var rating: Int = 0
    
    let castTypeSubject = PassthroughSubject<CastDetailType, Never>()
    
    @Inject
    private var repository: MovieRepository
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        castTypeSubject
            .flatMap { [weak self] participantType -> AnyPublisher<CastDetail, MovieError> in
                guard let self = self else {
                    return Fail(error: MovieError.unexpectedError).eraseToAnyPublisher()
                }
                let request = FetchCastMemberDetailRequest(memberId: participantType.id)
                switch participantType{
                case .castMember:
                    return self.repository.fetchCastMemberDetail(req: request)
                case .company:
                    return self.repository.fetchCompanyDetail(req: request)
                }
                
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            }, receiveValue: { [weak self] castDetail in
                self?.castDetail = castDetail
                self?.rating = self?.calculateStarRating(for: castDetail.popularity) ?? 0
            })
            .store(in: &cancellables)
    }
    
    private func calculateStarRating(for popularity: Double?) -> Int {
        guard let popularity = popularity else { return 0 }
        if popularity == 0 {
            return 0
        }
        
        let maxPopularity = 30.0 // Adjusted maximum for better scaling
        let scaledPopularity = min(popularity, maxPopularity)
        
        // Scale to a 0-4 range and add 1, so the minimum is 1 star
        let rating = (scaledPopularity / maxPopularity) * 4.0
        
        return Int(rating + 1.0)
    }
}
