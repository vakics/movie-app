//
//  movie_appApp.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 06..
//

import SwiftUI

@main
struct movie_app_liveApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State var selectedTab: TabType = TabType.genre
    
    @AppStorage("color-scheme") var colorScheme: Theme = .light

    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .preferredColorScheme(ColorScheme(theme: colorScheme))
        }
    }
}
