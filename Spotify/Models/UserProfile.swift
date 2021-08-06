//
//  UserProfile.swift
//  Spotify
//
//  Created by Justin Viasus on 8/1/21.
//

import Foundation

// Note: Codable: A type that can convert itself into and out of an external representation.

// The type adopts Codable so that it's decodable using a JSONDecoder instance.
struct UserProfile: Codable {
    let country: String
    let display_name: String
    let email: String
    let explicit_content: [String: Bool]
    let external_urls: [String: String]
    let id: String
    let product: String
    let images: [APIImage]
}
