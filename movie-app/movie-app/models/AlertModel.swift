//
//  AlertModel.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 26..
//

import Foundation

struct AlertModel: Identifiable{
    let id = UUID()
    let title: String
    let message: String
    let dismissButtonTitle: String
}
