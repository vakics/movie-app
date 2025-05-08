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
        case .fetchMovies:
            return "discover/movie"
        case .fetchTVShows:
            return "discover/tv"
        case .searchMovies:
            return "search/movie"
        case let .fetchFavoriteMovies(req):
            return "account/\(req.accountId)/favorite/movies"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchGenres, .fetchTVGenres, .fetchMovies, .searchMovies, .fetchTVShows, .fetchFavoriteMovies:
            return .get
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
        }
    }
    
    
}
