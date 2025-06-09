//
//  DetailLabel.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 10..
//

import SwiftUI

struct DetailLabel: View {
    let title: String
    let desc: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: LayoutConst.smallPadding){
            Text(title.localized())
                .font(Fonts.caption)
            Text(desc)
                .font(Fonts.paragraph)
        }
    }
}
