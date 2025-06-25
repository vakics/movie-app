//
//  ViewModelAssembly.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 15..
//

import Swinject
import Foundation

class ViewModelAssembly: Assembly{
    func assemble(container: Swinject.Container) {
        container.register((any MediaItemListViewModelProtocol).self) {_ in
            return MediaItemListViewModel()
        }.inObjectScope(.container)
        container.register((any GenreSectionViewModel).self) {_ in
            return GenreSectionViewModelImp()
        }.inObjectScope(.container)
        container.register((any SearchViewModelProtocol).self) { _ in
            return SearchViewModel()
        }.inObjectScope(.transient)
        
        container.register((any FavoriteViewModellProtocol).self) { _ in
            return FavoriteViewModell()
        }.inObjectScope(.transient)
        
        container.register((any SettingViewModelProtocol).self) { _ in
            return SettingViewModel()
        }.inObjectScope(.transient)
    }
}
