//
//  CustomError.swift
//  OsonTask
//
//  Created by Abdulloh Murodilloyev on 26/02/25.
//

import Foundation

enum CustomError: Error {
    case noInternetConnection
    case invalidResponse
    case noDataReceived
    case networkError(String)
    
    init(statusCode: Int) {
        switch statusCode {
        case 400...499:
            self = .invalidResponse
        case 500...599:
            self = .networkError("Server error")
        default:
            self = .networkError("Unknown error")
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .noInternetConnection:
            return "Internet connection is unavailable."
        case .invalidResponse:
            return "Invalid response from the server."
        case .noDataReceived:
            return "No data received from the server."
        case .networkError(let message):
            return message
        }
    }
}
