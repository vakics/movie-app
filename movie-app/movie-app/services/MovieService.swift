//
//  MovieService.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 12..
//

import Moya
import Foundation

protocol MovieServiceProtocol {
    func fetchGenres(req: FetchGenreRequest) async throws -> [Genre]
    func fetchTVGenres(req: FetchGenreRequest) async throws -> [Genre]
}

class MovieService: MovieServiceProtocol {
    var moya: MoyaProvider<MultiTarget>!
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        
        self.moya = MoyaProvider<MultiTarget>(
            session: Session(configuration: configuration, startRequestsImmediately: false),
            plugins: [
                NetworkLoggerPlugin()
            ]
        )
    }
    func fetchGenres(req: FetchGenreRequest) async throws -> [Genre] {
        return try await withCheckedThrowingContinuation { continuation in
                    moya.request(MultiTarget(MoviesApi.fetchGenres(req: req))) { result in
                        switch result {
                        case .success(let response):
                            do {
                                let decodedResponse = try JSONDecoder().decode(GenreListResponse.self, from: response.data)
//                                var genres = [Genre]()
//                                for genreResponse in decodedResponse.genres {
//                                    genres.append(Genre(dto: genreResponse))
//                                }
                                let genres = decodedResponse.genres.map{genreResponse in
                                    Genre(dto: genreResponse)
                                }
                                continuation.resume(returning: genres)
                            } catch {
                                continuation.resume(throwing: error)
                            }
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
                }
    }
    func fetchTVGenres(req: FetchGenreRequest) async throws -> [Genre] {
        return try await withCheckedThrowingContinuation{continuation in
            moya.request(MultiTarget(MoviesApi.fetchTVGenres(req: req))){result in
                switch result {
                case .success(let response):
                    do{
                        let decodedResponse = try JSONDecoder().decode(GenreListResponse.self, from: response.data)
                        let genres = decodedResponse.genres.map{genreResponse in
                            Genre(dto: genreResponse)
                        }
                        continuation.resume(returning: genres)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
}
