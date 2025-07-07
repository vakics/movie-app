//
//  RootView.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 17..
//


import SwiftUI
import Combine

struct RootView: View {
    @State var selectedTab: TabType = TabType.genre
    @StateObject private var viewModel = RootViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            NavbarView(selectedTab: $selectedTab)

            OfflineBannerView()
                .opacity(viewModel.isBannerVisible ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.3), value: viewModel.isBannerVisible)
        }
    }
}
