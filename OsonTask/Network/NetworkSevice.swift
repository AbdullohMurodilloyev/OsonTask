//
//  NetworkSevice.swift
//  OsonTask
//
//  Created by Abdulloh Murodilloyev on 26/02/25.
//

import Foundation
import Alamofire

struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()
    static var isConnectedToInternet: Bool {
        return sharedInstance?.isReachable ?? false
    }
}

typealias NetworkCompletion<T: Decodable> = (Result<T, CustomError>) -> Void

class NetworkService {
    static let baseURL = "https://jsonplaceholder.typicode.com/"
    
    // Generic request function using Decodable
    static func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        params: [String: Any]? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping NetworkCompletion<T>
    ) {
        // Check for internet connectivity
        guard Connectivity.isConnectedToInternet else {
            completion(.failure(.noInternetConnection))
            return
        }
        
        // Construct the full URL
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(.invalidResponse))
            return
        }
                
        // Perform the request
        AF.request(
            url,
            method: method,
            parameters: params,
            encoding: method == .get ? URLEncoding.default : JSONEncoding.default
        ).validate(statusCode: 200...299).responseDecodable(of: T.self) { response in
            if let statusCode = response.response?.statusCode {
                print("HTTP Status Code:", statusCode)
            }
            
            switch response.result {
            case .success(let decodedData):
                completion(.success(decodedData))
            case .failure(let error):
                if let statusCode = response.response?.statusCode {
                    let errorType = CustomError(statusCode: statusCode)
                    completion(.failure(errorType))
                } else {
                    completion(.failure(.networkError(error.localizedDescription)))
                }
            }
        }
    }
}
