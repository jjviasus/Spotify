//
//  APICaller.swift
//  Spotify
//
//  Created by Justin Viasus on 8/1/21.
//

import Foundation

// Note: look up session tasks, JSONDecoder, Sets, Result, and JSONSerialization.jsonObject in Swift

// Session Tasks: ???

// JSONDecoder: An object that decodes instances of a data type from JSON objects.

// Set: an unordered collection of unique elements.
//      You use a set instead of an array when:
//      - you need to test efficiently for membership and you aren't concerned with the order of the elements in the collection
//      - or when you need to ensure that each element appears only once in a collection

// Result: A value that represents either a success or a failure, including an associated value in each case.

// JSONSerialization: An object that converts between JSON and the equivalent Foundation objects.
// .jsonObject: Returns a Foundation object from given JSON data.
// We were using JSONSerialization.jsonObject to essentially getting raw json.

final class APICaller {
    static let shared = APICaller() // we are going to use a shared instance of the APICaller
    
    private init() {}
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    // our custom error
    enum APIError: Error {
        case failedToGetData
    }
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) { // A Result type takes a success and an error.
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/me"),
            type: .GET
        ) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                // if we successfully get data, we can convert it to json
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(result))
                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume() // whenever you have a task, make sure to call it
        }
    }
    
    public func getNewReleases(completion: @escaping ((Result<NewReleasesResponse, Error>)) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                // unwrap data
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                // convert data to json
                do {
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume() // this is how you kick off the session task
        }
    }
    
    public func getFeaturedPlaylists(completion: @escaping ((Result<FeaturedPlaylistsResponse, Error>) -> Void)) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?limit=2"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                // unwrap data
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                // convert data to json
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume() // this is how you kick off the session task
        }
    }
    
    public func getRecommendations(genres: Set<String>, completion: @escaping ((Result<RecommendationsResponse, Error>) -> Void)) {
        let seeds = genres.joined(separator: ",") // join the genres, separated by commas
            createRequest(
                with: URL(string: Constants.baseAPIURL + "/recommendations?limit=40&seed_genres=\(seeds)"),
                type: .GET
            ) { request in
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    // unwrap data
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
    
                    // convert data to json
                    do {
                        let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                        completion(.success(result))
                    }
                    catch {
                        completion(.failure(error))
                    }
                }
                task.resume() // this is how you kick off the session task
            }
        }
    
    public func getRecommendedGenres(completion: @escaping ((Result<RecommendedGenresResponse, Error>) -> Void)) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                // unwrap data
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                // convert data to json
                do {
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume() // this is how you kick off the session task
        }
    }
    
    // MARK: - Private
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    private func createRequest(
        with url: URL?,
        type: HTTPMethod,
        completion: @escaping (URLRequest) -> Void
    ) {
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else {
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)",
                             forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
}
