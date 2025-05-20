//
//  ParticipantCell.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 13..
//

import SwiftUI

struct ParticipantCell: View {
    let imageUrl: URL?
    let title: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 12.0) {
            LoadImageView(url: imageUrl)
            .frame(width: 56, height: 56)
            .cornerRadius(28)
            
            Text(title)
                .font(Fonts.subheading)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}
