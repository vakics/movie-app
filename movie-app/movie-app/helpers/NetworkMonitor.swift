//
//  NetworkMonitor.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 17..
//

import Foundation
import Reachability
import Combine

protocol NetworkMonitorProtocol{
    var isConnected: AnyPublisher<Bool, Never> {get}
}

class NetworkMonitor: NetworkMonitorProtocol {
    private let subject = PassthroughSubject<Bool, Never>()
    private var reachability: Reachability
    var isConnected: AnyPublisher<Bool, Never> {
        subject.eraseToAnyPublisher()
    }
    
    init() {
        guard let reachability = try? Reachability() else {
            fatalError("Failed to initialize Reachability")
        }
        
        self.reachability = reachability
        reachability.whenReachable = { [weak self]reachability in
            let available = reachability.connection != .unavailable
            self?.subject.send(available)
        }
        reachability.whenUnreachable = { [weak self] _ in
            self?.subject.send(false)
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}
