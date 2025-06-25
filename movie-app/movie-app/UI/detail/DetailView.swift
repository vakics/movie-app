//
//  DetailView.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 08..
//

import SwiftUI
import SafariServices

struct DetailView: View {
    @StateObject private var viewModel = DetailViewModel()
    let mediaItem: MediaItem
    let type: GenreType
    @Environment(\.dismiss) private var dismiss: DismissAction
    @State var isExpanded: Bool = false
    
    var body: some View {
        
        var mediaItemDetail: MediaItemDetail {
            viewModel.mediaItemDetail
        }
        
        var credits: [CastMember] {
            viewModel.credits
        }
        
        return ScrollView {
            VStack(alignment: .leading, spacing: LayoutConst.largePadding) {
                LoadImageView(url: mediaItemDetail.imageUrl)
                    .frame(height: 180)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(30)
                
                HStack(spacing: 12.0) {
                    MediaItemLabel(type: .rating(value: mediaItemDetail.rating))
                    MediaItemLabel(type: .voteCount(vote: mediaItemDetail.voteCount))
                    MediaItemLabel(type: .popularity(popularity: mediaItemDetail.popularity))
                    Spacer()
                    MediaItemLabel(type: .adult(adult: mediaItemDetail.adult))
                }
                
                Text(viewModel.mediaItemDetail.genreList)
                    .font(Fonts.paragraph)
                Text(viewModel.mediaItemDetail.title)
                    .font(Fonts.detailsTitle)
                
                HStack(spacing: LayoutConst.normalPadding) {
                    DetailLabel(title: "detail.releaseDate".localized(), desc: mediaItemDetail.year)
                    DetailLabel(title: "detail.runtime".localized(), desc: "\(mediaItemDetail.runtime)")
                    DetailLabel(title: "detail.language".localized(), desc: mediaItemDetail.spokenLanguages)
                }
                
                HStack {
                    NavigationLink(destination: AddReviewView(mediaItemDetail: mediaItemDetail)) {
                        StyledButton(style: .outlined, title: "detail.rate.button".localized(), action: .simple)
                    }
                    
                    Spacer()
                    StyledButton(style: .filled, title: "detail.imdb.button".localized(), action: .link(mediaItemDetail.imdbURL))
                }
                
                VStack(alignment: .leading, spacing: 12.0) {
                    Text("detail.overview".localized())
                        .font(Fonts.overviewText)
                    
                    Text(mediaItemDetail.overview)
                        .font(Fonts.paragraph)
                        .lineLimit(nil)
                }
                ParticipantScrollView(navigationType: .company,title: "detail.publishers".localized(), participants: mediaItemDetail.productionCompanies)
                
                ParticipantScrollView(navigationType: .person, title: "detail.cast".localized(), participants: credits)
                
                VStack{
                    HStack {
                        Text("Similar").font(Fonts.title)
                            .foregroundStyle(.primary)
                        Spacer()
                        RotatingArrow(isExpanded: isExpanded)
                            .onTapGesture {
                                isExpanded.toggle()
                            }
                    }
                    MediaItemScrollView(mediaItems: viewModel.similarItems, isLoading: viewModel.isLoading, reachedEndSubject: viewModel.reachedEndSubject, type: type)
                }
            }
            .padding(.horizontal, LayoutConst.maxPadding)
            .padding(.bottom, LayoutConst.largePadding)
            
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    viewModel.favoriteButtonTapped.send(())
                }) {
                    Image(viewModel.isFavorite ? .favoriteHeart : .nonfavorite)
                        .resizable()
                        .frame(height: 30.0)
                        .frame(width: 30.0)
                }
            }
        }
        .showAlert(model: $viewModel.alertModel)
        .onAppear {
            print("<<<DEBUG - onAppear with id: \(mediaItem.id)")
            viewModel.mediaItemIdSubject.send(mediaItem.id)
            viewModel.typeSubject.send(type)
        }
    }
}

extension UIApplication {
    // 3
    var firstKeyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
            .first?.keyWindow
    }
}
