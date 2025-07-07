//
//  SettingViewModel.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 27..
//

import Foundation
import SwiftUI
import InjectPropertyWrapper

protocol SettingViewModelProtocol: ObservableObject{
    
}

class SettingViewModel: SettingViewModelProtocol {
    @Published var selectedLanguage: String = Bundle.getLangCode()
    private let themeKey = "color-scheme"
    @Published var selectedTheme: Theme{
        didSet{
            UserDefaults.standard.set(selectedTheme.rawValue, forKey: themeKey)
        }
    }
    
    @AppStorage("color-scheme") var colorSchemeRawValue: String = "light"
    @Published var appInfo: String = ""
    
    @Inject
    private var appVersionProvider: AppVersionProviderProtocol
    
    init() {
        let storedTheme = UserDefaults.standard.string(forKey: themeKey)
        self.selectedTheme = Theme(rawValue: storedTheme ?? "") ?? .light
        appInfo = appVersionProvider.version + " (" + appVersionProvider.build + ")"
    }
    
    func changeSelectedLanguge(_ language: String) {
        self.selectedLanguage = language
        Bundle.setLanguage(lang: language)
    }
    
    func changeTheme(_ theme: Theme) {
        self.selectedTheme = theme
    }
    
}
