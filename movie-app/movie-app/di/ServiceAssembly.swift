//
//  ServiceAssembly.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 15..
//

import Swinject
import Moya
import Foundation

class ServiceAssembly: Assembly{
    func assemble(container: Swinject.Container) {
        container.register(MoyaProvider<MultiTarget>.self) { _ in
            let configuration = URLSessionConfiguration.default
            configuration.headers = .default
            return MoyaProvider<MultiTarget>(
                session: Session(configuration: configuration, startRequestsImmediately: false),
                plugins: [
                    NetworkLoggerPlugin(
                        configuration:  NetworkLoggerPlugin.Configuration(output: {_, items in
                            for item in items{
                                print("Response: \(item)")
                            }
                        },
                        logOptions: .verbose))
                ]
            )
        }.inObjectScope(.container)
//        a movieservice objectből mindig ugyanazt adja vissza
//        ha mindig új kell, transient
        container.register(MovieServiceProtocol.self) {_ in 
            return MovieService()
//            return MockMoviesService()
        }.inObjectScope(.container)
        
        container.register(ReactiveMoviesServiceProtocol.self) {_ in
            return ReactiveMoviesService()
        }.inObjectScope(.container)
    }
}
