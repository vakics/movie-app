//
//  movie_appApp.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 06..
//

import SwiftUI

@main
struct movie_appApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var selectedTab: TabType = TabType.genre
    var body: some Scene {
        WindowGroup {
            RootView(selectedTab: selectedTab)
        }
    }
}
