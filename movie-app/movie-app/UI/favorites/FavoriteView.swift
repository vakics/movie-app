//
//  FavoriteView.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 04..
//

import SwiftUI
import InjectPropertyWrapper

struct FavoritesView: View {
    @StateObject private var viewModel = FavoriteViewModell()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: LayoutConst.normalPadding) {
                    ForEach(viewModel.mediaItems.indices, id: \.self) { index in
                        let movie = viewModel.mediaItems[index]
                        NavigationLink(destination: DetailView(mediaItem: movie)) {
                            MediaItemCellView(movie: movie)
                                .frame(height: 277)
                        }
                        .accessibilityLabel("MediaItem\(index)")
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, LayoutConst.normalPadding)
                .padding(.top, LayoutConst.normalPadding)
            }
            .navigationTitle("favoriteMovies.title".localized())
            .accessibilityLabel(AccessibilityLabels.favoritesScrollView)
        }
        .showAlert(model: $viewModel.alertModel)
        .onAppear {
            viewModel.viewLoaded.send(())
        }
    }
}
#Preview {
    FavoritesView()
}
