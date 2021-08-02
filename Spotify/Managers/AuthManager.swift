//
//  AuthManager.swift
//  Spotify
//
//  Created by Justin Viasus on 8/1/21.
//

import Foundation

// Note: Managers are objects in the app that allow us to perform operations across the whole app. For example: Authentication Management (AuthManager), to make sure the user is logged in.

// AuthManager is responsible for making sure the user is signed in, signing them in, etc.

final class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    var isSignedIn: Bool {
        return false
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExpirationDate: Date? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false
    }
}
