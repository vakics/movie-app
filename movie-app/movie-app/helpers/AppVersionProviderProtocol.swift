//
//  AppVersionProviderProtocol.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 06. 30..
//


import Foundation

protocol AppVersionProviderProtocol {
    var version: String { get }
    var build: String { get }
}

 class AppVersionProvider: AppVersionProviderProtocol {
    let version: String
    let build: String

    init(bundle: Bundle = .main) {
        let info = bundle.infoDictionary
        self.version = info?["CFBundleShortVersionString"] as? String ?? "N/A"
        self.build = info?["CFBundleVersion"] as? String ?? "N/A"
    }
}