//
//  RootViewModel.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 17..
//


import Foundation
import InjectPropertyWrapper
import Combine

class RootViewModel: ObservableObject {
    
    @Inject
    private var networkMonitor: NetworkMonitorProtocol
    
    @Published var isBannerVisible: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        networkMonitor.isConnected
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self]isConnected in
                if !isConnected{
                    self?.isBannerVisible = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                        self?.isBannerVisible = false
                    }
                }
            })
            .store(in: &cancellables)
    }
}
