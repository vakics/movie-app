//
//  ErrorPrentable.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 05. 06..
//

protocol ErrorPrentable {
    func toAlertModel(_ error: Error) -> AlertModel
}

extension ErrorPrentable {
    func toAlertModel(_ error: Error)->AlertModel{
        guard let error = error as? MovieError else {
            return AlertModel(title: "error.unexpected.title", message: "error.unexpected.desc", dismissButtonTitle: "error.close")
        }
        switch error{
        case .invalidApiKeyError(let message):
            return AlertModel(title: "error.api.title", message: message, dismissButtonTitle: "error.close")
        case .clientError:
            return AlertModel(title: "Client error", message: error.localizedDescription, dismissButtonTitle: "error.close")
        default:
            return AlertModel(title: "error.unexpected.title", message: "error.unexpected.desc", dismissButtonTitle: "error.close")
        }
    }
}
