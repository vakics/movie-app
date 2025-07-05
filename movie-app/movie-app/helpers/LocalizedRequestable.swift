//
//  LocalizedRequestable.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 07. 02..
//
import Foundation

protocol LocalizedRequestable {
    var languageParam: [String: Any] { get }
}

extension LocalizedRequestable {
    var languageParam: [String: Any] {
        ["language": Bundle.getLangCode()]
    }
}

func + (lhs: [String: Any], rhs: [String: Any]) -> [String: Any] {
    var result = lhs
    rhs.forEach { result[$0.key] = $0.value }
    return result
}
