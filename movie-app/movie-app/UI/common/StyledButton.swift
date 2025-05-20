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

struct StyledButton: View {
    let style: ButtonStyleType
    let title: String
    var action: () -> Void = {}
    var body: some View {
        Button(action: action){
            Text(LocalizedStringKey(title))
                .font(Fonts.subheading)
                .foregroundColor(style == .outlined ? .primary : .main)
                .padding(.horizontal, 32.0)
                .padding(.vertical, LayoutConst.normalPadding)
                .background(backgroundView)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.primary, lineWidth: style == .outlined ? 1 : 0))
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
