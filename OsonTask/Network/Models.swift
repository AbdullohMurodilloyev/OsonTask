//
//  Models.swift
//  OsonTask
//
//  Created by Abdulloh Murodilloyev on 26/02/25.
//

import Foundation

// MARK: TODOS MODEL
struct TodosModel: Codable {
    let userId, id: Int
    let title: String
    let completed: Bool

    enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case id, title, completed
    }
}

// MARK: USER MODEL
struct UserModel: Codable {
    let id: Int
       let name, username, email: String
       let address: Address
       let phone, website: String
       let company: Company
}

// MARK: - Address
struct Address: Codable {
    let street, suite, city, zipcode: String
      let geo: Geo
}

// MARK: - Geo
struct Geo: Codable {
    let lat, lng: String
}

// MARK: - Company
struct Company: Codable {
    let name, catchPhrase, bs: String
}
