//
//  RecommendedGenresResponse.swift
//  Spotify
//
//  Created by Justin Viasus on 8/4/21.
//

import Foundation

// Response object for Recommended Genres Response

struct RecommendedGenresResponse: Codable {
    let genres: [String]
}
