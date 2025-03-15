//
//  NetworkError.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 15/03/2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case networkFailure(Error)
    case unauthorized
    case serverError(statusCode: Int)

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .noData:
            return "No data received from the server."
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .networkFailure(let error):
            return "Network failure: \(error.localizedDescription)"
        case .unauthorized:
            return "Unauthorized request."
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)."
        }
    }
}
