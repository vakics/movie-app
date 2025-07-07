//
//  AddReviewView.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 23..
//


import SwiftUI

struct AddReviewView: View {
    
    let mediaItemDetail: MediaItemDetail
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = AddReviewViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: LayoutConst.normalPadding) {
                MediaItemHeaderView(title: viewModel.mediaItemDetail.title,
                                    year: viewModel.mediaItemDetail.year,
                                    runtime: "\(viewModel.mediaItemDetail.runtime)",
                                    spokenLanguages: viewModel.mediaItemDetail.spokenLanguages)
                LoadImageView(url: mediaItemDetail.imageUrl)
                    .frame(height: 185)
                    .cornerRadius(30)
                Text("addReview.subTitle".localized())
                    .font(Fonts.detailsTitle)
                HStack {
                    Spacer()
                    VStack (spacing: 72.0){
                        StarRatingView(rating: $viewModel.selectedRating)
                        StyledButton(style: .filled, title: "addReview.buttonTitle", action: .simple)
                            .onTapGesture {
                                viewModel.ratingBtnSubject.send()
                            }
                    }
                    Spacer()
                }
                Spacer()
            }
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, LayoutConst.maxPadding)
        .showAlert(model: $viewModel.alertModel)
        .onAppear {
            viewModel.mediaDetailSubject.send(mediaItemDetail)
        }
        .onChange(of: viewModel.success) {
            dismiss()
        }
    }
}
