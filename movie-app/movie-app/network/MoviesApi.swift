//
//  MoviesApi.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 12..
//

import Foundation
import Moya

enum MoviesApi {
    case fetchGenres(req: FetchGenreRequest)
    case fetchTVGenres(req: FetchGenreRequest)
    case fetchMovies(req: FetchMoviesRequest)
    case fetchTVShows(req: FetchMoviesRequest)
    case searchMovies(req: SearchMoviesRequest)
    case fetchFavoriteMovies(req: FetchFavoriteMovieRequest)
    case fetchMovieDetail(req: FetchDetailRequest)
    case fetchTVDetail(req: FetchDetailRequest)
    case fetchMovieCredits(req: FetchMovieCreditsRequest)
    case editFavoriteMovie(req: EditFavoriteRequest)
    case addReview(req: AddReviewRequest)
    case fetchCastMemberDetail(req: FetchCastMemberDetailRequest)
    case fetchCompanyDetail(req: FetchCastMemberDetailRequest)
    case fetchSimilarMovies(req: FetchSimilarMovie)
    case fetchCombinedCredits(req: FetchCastMemberDetailRequest)
    case fetchRandomMovies(req: FetchRandomMediaItems)
    case fetchRandomTvShows(req: FetchRandomMediaItems)
}

extension MoviesApi: TargetType {
    var baseURL: URL {
        let baseUrl = "https://api.themoviedb.org/3/"
        guard let baseUrl = URL(string: baseUrl) else {
            preconditionFailure("Base url not working")
        }
        return baseUrl
    }
    
    var path: String {
        switch self {
        case .fetchGenres:
            return "genre/movie/list"
        case .fetchTVGenres:
            return "genre/tv/list"
        case .fetchMovies, .fetchRandomMovies:
            return "discover/movie"
        case .fetchTVShows, .fetchRandomTvShows:
            return "discover/tv"
        case .searchMovies:
            return "search/movie"
        case let .fetchFavoriteMovies(req):
            return "account/\(req.accountId)/favorite/movies"
        case let .fetchMovieDetail(req):
            return "movie/\(req.mediaId)"
        case .fetchMovieCredits(req: let req):
            return "movie/\(req.mediaId)/credits"
        case .editFavoriteMovie(req: let req):
            return "account/\(req.accountId)/favorite"
        case .addReview(req: let req):
            return "movie/\(req.mediaId)/rating"
        case .fetchCastMemberDetail(req: let req):
            return "person/\(req.memberId)"
        case .fetchCompanyDetail(req: let req):
            return "company/\(req.memberId)"
        case .fetchSimilarMovies(req: let req):
            return "movie/\(req.movieId)/similar"
        case .fetchTVDetail(req: let req):
            return "tv/\(req.mediaId)"
        case .fetchCombinedCredits(req: let req):
            return "person/\(req.memberId)/combined_credits"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchGenres, .fetchTVGenres, .fetchMovies, .searchMovies, .fetchTVShows, .fetchFavoriteMovies, .fetchMovieDetail, .fetchMovieCredits, .fetchCastMemberDetail, .fetchCompanyDetail, .fetchSimilarMovies, .fetchTVDetail, .fetchCombinedCredits, .fetchRandomMovies, .fetchRandomTvShows:
            return .get
        case .editFavoriteMovie, .addReview :
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
            //            kell a let hogy elérjük a paramétert
        case let .fetchGenres(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchTVGenres(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchMovies(req):
            return.requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchTVShows(req):
            return.requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .searchMovies(req):
            return.requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchFavoriteMovies(req):
            return.requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchMovieDetail(req):
            return.requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchMovieCredits(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .editFavoriteMovie(req: let req):
            //return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.httpBody)
            let request = EditFavoriteBodyRequest(movieId: req.movieId, isFavorite: req.isFavorite)
            return .requestJSONEncodable(request)
        case let .addReview(req):
            let request = AddReviewBodyRequest(movieId: req.mediaId, rating: req.rating)
            return .requestJSONEncodable(request)
        case .fetchCastMemberDetail(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .fetchCompanyDetail(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .fetchSimilarMovies(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .fetchTVDetail(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .fetchCombinedCredits(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .fetchRandomMovies(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .fetchRandomTvShows(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .fetchGenres(req):
            return ["Authorization": req.accessToken]
        case let .fetchTVGenres(req):
            return ["Authorization": req.accessToken]
        case let .fetchMovies(req):
            return ["Authorization": req.accessToken]
        case let .fetchTVShows(req):
            return ["Authorization": req.accessToken]
        case let .searchMovies(req):
            return ["Authorization": req.accessToken]
        case let .fetchFavoriteMovies(req):
            return ["Authorization": req.accessToken]
        case let .fetchMovieDetail(req):
            return ["Authorization": req.accessToken]
        case let .fetchMovieCredits(req):
            return ["Authorization": req.accessToken]
        case .editFavoriteMovie(req: let req):
            return [
                "Authorization": req.accessToken,
                "accept": "application/json"
            ]
        case .addReview(req: let req):
            return [
                "Authorization": req.accessToken,
                "accept": "application/json"
            ]
        case .fetchCastMemberDetail(req: let req):
            return ["Authorization": req.accessToken]
        case .fetchCompanyDetail(req: let req):
            return ["Authorization": req.accessToken]
        case .fetchSimilarMovies(req: let req):
            return ["Authorization": req.accessToken]
        case .fetchTVDetail(req: let req):
            return ["Authorization": req.accessToken]
        case .fetchCombinedCredits(req: let req):
            return ["Authorization": req.accessToken]
        case .fetchRandomMovies(req: let req):
            return ["Authorization": req.accessToken]
        case .fetchRandomTvShows(req: let req):
            return ["Authorization": req.accessToken]
        }
    }
}
