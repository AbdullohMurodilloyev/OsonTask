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
    case serverError(Int) // Handle specific HTTP errors
    case unknownError(String)

    init(statusCode: Int) {
        switch statusCode {
        case 400...499:
            self = .serverError(statusCode) // Client errors
        case 500...599:
            self = .serverError(statusCode) // Server errors
        default:
            self = .unknownError("Unknown error occurred with status code: \(statusCode)")
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .noInternetConnection:
            return "No internet connection available"
        case .invalidResponse:
            return "Invalid response received from server"
        case .noDataReceived:
            return "No data received from server"
        case .networkError(let message):
            return message
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)"
        case .unknownError(let message):
            return message
        }
    }
}
