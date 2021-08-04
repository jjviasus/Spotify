//
//  RecommendationsResponse.swift
//  Spotify
//
//  Created by Justin Viasus on 8/4/21.
//

import Foundation

// Note: Look up Codable in Swift

struct RecommendationsResponse: Codable {
    let tracks: [AudioTrack]
}

