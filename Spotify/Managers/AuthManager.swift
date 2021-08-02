//
//  AuthManager.swift
//  Spotify
//
//  Created by Justin Viasus on 8/1/21.
//

import Foundation

// Note: Managers are objects in the app that allow us to perform operations across the whole app. For example: Authentication Management (AuthManager), to make sure the user is logged in.

// AuthManager is responsible for handling all the authentication logic.
final class AuthManager {
    static let shared = AuthManager()
    
    struct Constants {
        static let clientID = "4b8d8d425f0242568842aff612a38f86"
        static let clientSecret = "da91102a89504834bc9a1a9866c3633c" // for security, you'd normally want to keep the client secret on a backend server (not here)
    }
    
    private init() {}
    
    public var signInURL: URL? {
        let scopes = "user-read-private"
        let redirectURI = "https://www.iosacademy.io"
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    
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
    
    public func exchangeCodeForToken(
        code: String,
        completion: @escaping ((Bool) -> Void)
    ) {
        // Get Token
    }
    
    public func refreshAccessToken() {
        
    }
    
    private func cacheToken() {
        
    }
}
