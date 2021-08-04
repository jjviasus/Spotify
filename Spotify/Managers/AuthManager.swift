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
    
    private var refreshingToken = false
    
    struct Constants {
        static let clientID = "4b8d8d425f0242568842aff612a38f86"
        static let clientSecret = "da91102a89504834bc9a1a9866c3633c" // for security, you'd normally want to keep the client secret on a backend server (not here)
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://www.iosacademy.io"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    
    private init() {}
    
    public var signInURL: URL? {
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil // if it does not equal nil, then we know the user is signed in
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    // we want to refresh the token when there are 10 minutes left
    private var shouldRefreshToken: Bool {
        // get the expiration date
        guard let expirationDate = tokenExpirationDate else { return false }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    public func exchangeCodeForToken(
        code: String,
        completion: @escaping ((Bool) -> Void)
    ) {
        // Get Token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type",
                         value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "Post"
        request.setValue("application/x-www-form-urlencoded ", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8) // encode the data with utf8
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base64")
            completion(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in // weak self to prevent memory leak b/c we are in a closure
            guard let data = data,
                  error == nil else {
                completion(false)
                return
                
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    private var onRefreshBlocks = [((String) -> Void)]()
    
    /// Supplies valid token to be used with API Calls
    public func withValidToken(completion: @escaping (String) -> Void) {
        guard !refreshingToken else {
            // Append the completion
            onRefreshBlocks.append(completion)
            return
        }
        
        if shouldRefreshToken {
            // Refresh
            refreshIfNeeded { [weak self] success in
                if let token = self?.accessToken, success {
                    completion(token)
                }
            }
        }
        else if let token = accessToken {
            completion(token)
        }
    }
    
    public func refreshIfNeeded(completion: ((Bool) -> Void)?) { // completion block is optional b/c instead of waiting for an api call to go and refresh the token, in our app delegate what we are going to do is if the user is signed in let's already start refreshing the token if needed, but we don't want a completion handler for it. As soon as our app launches, it will start refreshing the token if needed. So we'll have a valid token right from the beginning.
        
        // make sure we are not already refreshing
        guard !refreshingToken else {
            return
        }
        
        guard shouldRefreshToken else {
            // we don't need to refresh
            completion?(true)
            return
        }
        
        // we need to refresh
        guard let refreshToken = self.refreshToken else { return }
        
        // Refresh the token
        
        // Get Token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        refreshingToken = true
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type",
                         value: "refresh_token"),
            URLQueryItem(name: "refresh_token",
                         value: refreshToken),
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "Post"
        request.setValue("application/x-www-form-urlencoded ", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8) // encode the data with utf8
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base64")
            completion?(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in // weak self to prevent memory leak b/c we are in a closure
            self?.refreshingToken = false
            guard let data = data,
                  error == nil else {
                completion?(false)
                return
                
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.onRefreshBlocks.forEach { $0(result.access_token) } // for each, we can execute the block and pass back the token
                self?.onRefreshBlocks.removeAll() // remove everything so we don't redudantly call one of the blocks we have saved
                self?.cacheToken(result: result)
                completion?(true)
            } catch {
                print(error.localizedDescription)
                completion?(false)
            }
        }
        task.resume()
    }
    
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refresh_token = result.refresh_token {
            // we cache it if it is not nil. we do this b/c nil will overwrite the initial token that we cached.
            UserDefaults.standard.setValue(result.refresh_token, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate") // cache the current time the user logged in plus the number of seconds it expires in (this will give us an expiration date)
    }
}
