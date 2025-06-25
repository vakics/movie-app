//
//  MediaItemScrollView.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 06. 23..
//
import SwiftUI
import Lottie
import Combine

struct MediaItemScrollView: View{
    let mediaItems: [MediaItem]
    var isLoading: Bool
    let reachedEndSubject: PassthroughSubject<Void, Never>
    let type: GenreType
    
    var body: some View{
        ScrollView(.horizontal){
            LazyHStack(spacing: 20){
                ForEach(mediaItems){mediaItem in
                    NavigationLink(destination: DetailView(mediaItem: mediaItem, type: type)){
                        MediaItemCellView(movie: mediaItem)
                            .frame(width: 200)
                            .onAppear {
                                if mediaItems.last?.id == mediaItem.id{
                                    reachedEndSubject.send()
                                }
                            }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                if isLoading{
                    LottieView(animation: LottieAnimation.named("loading"))
                        .playing(loopMode: .loop)
                        .frame(width: 200.0, height: 200.0)
                }
            }
        }
        .listRowBackground(Color.clear)
    }
}
