//
//  SettingsView.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 25..
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView{
            VStack (alignment: .leading) {
                ZStack {
                    VStack {
                        HStack{
                            Spacer()
                            Image(.redCirclePart)
                        }
                        Spacer()
                    }.ignoresSafeArea()
                    VStack (alignment: .leading){
                        SettingBlock(title: "setting.language", buttons: [
                            StyledButton(style: .outlined, title: "English", action: .simple),
                            StyledButton(style: .outlined, title: "Deutsche", action: .simple),
                            StyledButton(style: .filled, title: "Hungarian", action: .simple)
                        ])
                        .padding(.horizontal, LayoutConst.maxPadding)
                        .padding(.top, 100)
                        .padding(.bottom, 43)
                        SettingBlock(title: "setting.mode", buttons: [
                            StyledButton(style: .outlined, title: "Light mode", action: .simple),
                            StyledButton(style: .filled, title: "Dark mode", action: .simple)
                        ])
                        .padding(.horizontal, LayoutConst.maxPadding)
                        Spacer()
                        VStack (alignment: .center){
                            HStack{
                                Spacer()
                                Text("version 0.9.1")
                                    .font(Fonts.subheading)
                                    .padding(.bottom, LayoutConst.normalPadding)
                                Spacer()
                            }
                            HStack{
                                Spacer()
                                Text("created by g0nZ0")
                                    .font(Fonts.subheading)
                                    .padding(.bottom, 43)
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle("navbar.settings")
        }
    }
}
