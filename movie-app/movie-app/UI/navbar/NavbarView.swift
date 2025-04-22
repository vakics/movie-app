//
//  NavbarView.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 17..
//

import SwiftUI

struct NavbarView: View {
    @State private var movieTitle: String = ""
    var body: some View {
        TabView{
            NavigationView{
                MainTab()
            }.tabItem{
                Label("Home", systemImage: "house.fill")
            }
            
            NavigationView{
                SearchView(movieTitle: movieTitle).searchable(text: $movieTitle)
            }.tabItem{
                Label("Search", systemImage: "magnifyingglass")
            }
        }
    }
}

#Preview {
    NavbarView()
}
