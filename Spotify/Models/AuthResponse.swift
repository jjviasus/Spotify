//
//  AuthResponse.swift
//  Spotify
//
//  Created by Justin Viasus on 8/2/21.
//

import Foundation

struct AuthResponse: Codable { // needs to be codable so we can automatically convert the json into this object
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}
