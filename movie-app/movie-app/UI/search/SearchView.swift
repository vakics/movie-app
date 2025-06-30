//
//  SearchView.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 17..
//

import SwiftUI
import InjectPropertyWrapper
import Combine

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 12) {
                    Image(.magnifyingGlass)
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                    
                    TextField("",
                              text: $viewModel.searchText,
                              prompt: Text("search.textfield.placeholder".localized())
                        .foregroundStyle(.invertedMain)
                    )
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(Fonts.caption)
                    .foregroundColor(.invertedMain)
                    .onChange(of: viewModel.searchText) {
                        viewModel.startSearch.send(())
                    }
                }
                .frame(height: 56)
                .padding(.horizontal, LayoutConst.normalPadding)
                .background(Color.searchForeground)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.white, lineWidth: 1)
                )
                .cornerRadius(28)
                .padding(.horizontal, LayoutConst.largePadding)
                
                if viewModel.movies.isEmpty {
                    // Üres állapot
                    VStack {
                        Spacer()
                        Text("search.empty.title".localized())
                            .multilineTextAlignment(.center)
                            .font(Fonts.emptyStateText)
                            .foregroundColor(.white)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewModel.movies) { movie in
                                MediaItemCellView(movie: movie)
                                    .frame(height: 277)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, LayoutConst.normalPadding)
                    }
                }
            }
        }
    }
}



#Preview {
    SearchView()
        .preferredColorScheme(.dark)
}
