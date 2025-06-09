//
//  SettingBlock.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 25..
//

import SwiftUI

struct SettingBlock: View {
    let title: String
    let buttons: [StyledButton]
    var body: some View {
        VStack (alignment: .leading){
            Text(LocalizedStringKey(title))
                .font(Fonts.subheading)
                .padding(.bottom, LayoutConst.maxPadding)
            HStack{
                ForEach(0..<buttons.count) { index in
                    buttons[index]
                        .padding(.horizontal, LayoutConst.smallPadding)
                        .lineLimit(1)
                        .fixedSize()
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}
