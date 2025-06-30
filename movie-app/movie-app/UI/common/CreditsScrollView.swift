//
//  CreditsScrollView.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 06. 26..
//

import SwiftUI

struct CreditsScrollView: View{
    let mediaItems: [CombinedMediaItem]
    
    var body: some View{
        ScrollView(.horizontal){
            LazyHStack(spacing: 20){
                ForEach(mediaItems, id: \.mediaItem.id){mediaItem in
                    NavigationLink(destination: DetailView(mediaItem: mediaItem.mediaItem)){
                        VStack{
                            MediaItemCellView(movie: mediaItem.mediaItem)
                                .frame(width: 200)
                            if(mediaItem.character != ""){
                                Text("As \(mediaItem.character)")
                                    .font(Fonts.subheading)
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .listRowBackground(Color.clear)
        .scrollIndicators(.hidden)
    }
}
