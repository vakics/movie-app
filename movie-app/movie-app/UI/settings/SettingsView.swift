//
//  SettingsView.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 25..
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingViewModel()
    var body: some View {
        NavigationView{
            VStack(alignment: .leading) {
                Text("settings.chooseLanguage".localized())
                    .font(Fonts.subheading)
                    .padding(.bottom, LayoutConst.maxPadding)
                HStack(spacing: 12) {
                    StyledButton(style: viewModel.selectedLanguage == "en" ? .filled : .outlined, title: "settings.lang.english".localized(), action: .simple)
                        .font(Fonts.detailsTitle)
                        .lineLimit(1)
                        .fixedSize()
                        .onTapGesture {
                            viewModel.changeSelectedLanguge("en")
                        }
                    StyledButton(style: viewModel.selectedLanguage == "ru" ? .filled : .outlined, title: "settings.lang.russian".localized(), action: .simple)
                        .font(Fonts.detailsButton)
                        .lineLimit(1)
                        .fixedSize()
                        .onTapGesture {
                            viewModel.changeSelectedLanguge("ru")
                        }
                    StyledButton(style: viewModel.selectedLanguage == "hu" ? .filled : .outlined, title: "settings.lang.hungarian".localized(), action: .simple)
                        .font(Fonts.detailsButton)
                        .lineLimit(1)
                        .fixedSize()
                        .onTapGesture {
                            viewModel.changeSelectedLanguge("hu")
                        }
                }
                .padding(.bottom, 43)
                Text("settings.chooseTheme".localized())
                    .font(Fonts.subheading)
                    .padding(.bottom, LayoutConst.maxPadding)
                HStack(spacing: 12) {
                    StyledButton(style: viewModel.selectedTheme == .light ? .filled : .outlined, title: "settings.theme.light".localized(), action: .simple)
                        .font(Fonts.detailsButton)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            viewModel.changeTheme(.light)
                        }
                    StyledButton(style: viewModel.selectedTheme == .dark ? .filled : .outlined, title: "settings.theme.dark".localized(), action: .simple)
                        .font(Fonts.detailsButton)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            viewModel.changeTheme(.dark)
                        }
                }
                .padding(.bottom, 43)
                Spacer()
                VStack(spacing: LayoutConst.smallPadding) {
                    Text("Version \(viewModel.appInfo)")
                    Text("Created by vakics")
                }
                .font(Fonts.subheading)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 66)
            }
            .padding(LayoutConst.maxPadding)
            .navigationTitle("settings.title".localized())
            .frame(maxHeight: .infinity, alignment: .top)
        }

    }
}
