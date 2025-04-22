//
//  EmptyModifier.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 17..
//

import SwiftUICore

struct EmptyModifier: ViewModifier {

    let isEmpty: Bool

    func body(content: Content) -> some View {
        Group {
            if isEmpty {
                Text("Kezdj el gépelni!").font(Fonts.title)
            } else {
                content
            }
        }
    }
}
