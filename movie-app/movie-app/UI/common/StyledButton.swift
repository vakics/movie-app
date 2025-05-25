//
//  StyledButton.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 10..
//
import SwiftUI

enum ButtonStyleType{
    case outlined
    case filled
}

enum ButtonStyleAction {
    case simple
    case link(_ url: URL?)
}


struct StyledButton: View {
    let style: ButtonStyleType
    let title: String
    var action: ButtonStyleAction
    var body: some View {
        baseView
            .font(Fonts.subheading)
            .foregroundColor(style == .outlined ? .primary : .main)
            .padding(.horizontal, 20.0)
            .padding(.vertical, LayoutConst.normalPadding)
            .background(backgroundView)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.primary, lineWidth: style == .outlined ? 1 : 0)
            )
    }
    @ViewBuilder
    private var baseView: some View {
        switch action {
        case .simple:
            Text(LocalizedStringKey(title))
        case .link(let url):
            if let url = url {
                Link(LocalizedStringKey(title), destination: url)
            } else {
                Text(LocalizedStringKey(title))
            }
            
        }
    }
    private var backgroundView: some View {
        switch style {
        case .filled:
            Color.primary
        case .outlined:
            Color.main
        }
    }
}

