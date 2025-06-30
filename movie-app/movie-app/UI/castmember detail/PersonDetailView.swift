//
//  PersonDetailView.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 06. 14..
//


import SwiftUI

struct CastDetailView: View {
    @StateObject private var viewModel = CastDetailViewModel()
    @Environment(\.dismiss) private var dismiss
    
    let castDetailType: CastDetailType
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                ScrollView {
                    if let castDetail = viewModel.castDetail {
                        VStack(alignment: .leading, spacing: 24) {
                            HStack {
                                Spacer()
                                LoadImageView(url: castDetail.imageURL)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 370, height: 185)
                                    .cornerRadius(20)
                                Spacer()
                            }
                            
                            Text(castDetail.name)
                                .font(Fonts.detailsTitle)
                                .foregroundColor(Color.primary)
                                .padding(.horizontal)
                            
                            HStack(spacing: 40) {
                                VStack(alignment: .leading) {
                                    Text("Birth year")
                                        .font(Fonts.caption)
                                        .foregroundColor(Color.primary)
                                    Text(castDetail.birthYear?.split(separator: "-").first.map(String.init) ?? "N/A")
                                        .font(Fonts.paragraph)
                                        .foregroundColor(Color.primary)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("City")
                                        .font(Fonts.caption)
                                        .foregroundColor(Color.primary)
                                    Text(castDetail.originPlace ?? "")
                                        .font(Fonts.paragraph)
                                        .foregroundColor(Color.primary)
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Bio")
                                    .font(Fonts.caption)
                                    .foregroundColor(Color.primary)
                                Text(castDetail.biography)
                                    .font(Fonts.paragraph)
                                    .foregroundColor(Color.primary)
                            }
                            .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Popularity")
                                    .font(Fonts.caption)
                                    .foregroundColor(Color.primary)
                                HStack {
                                    Spacer()
                                    StarRatingView(rating: $viewModel.rating, starSize: 24)
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                            
                            if viewModel.credits.count != 0{
                                Text("Casted in")
                                    .font(Fonts.title)
                                    .padding(.horizontal)
                                CreditsScrollView(mediaItems: viewModel.credits)
                            }
                            
                        }
                        .padding(.bottom, 48)
                    } else {
                        ProgressView()
                    }
                }
            }
        }
        .showAlert(model: $viewModel.alertModel)
        .onAppear {
            viewModel.castTypeSubject.send(castDetailType)
        }
    }
}
