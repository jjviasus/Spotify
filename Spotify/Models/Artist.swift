//
//  Artist.swift
//  Spotify
//
//  Created by Justin Viasus on 8/1/21.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let external_urls: [String: String]
}
