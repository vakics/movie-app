//
//  Theme.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 31..
//

import Foundation
import SwiftUI

enum Theme: String{
    case dark
    case light
}

extension ColorScheme{
    init(theme: Theme){
        switch theme{
        case .light:
            self = .light
        case .dark:
            self = .dark
        }
    }
    var asTheme: Theme{
        switch self{
        case .light:
            return .light
        case .dark:
            return .dark
        @unknown default:
            return .light
        }
    }
}
