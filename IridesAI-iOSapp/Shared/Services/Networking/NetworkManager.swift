//
//  NetworkManager.swift
//  Lamei
//
//  Created by Siddharth S on 07/09/24.
//

import Foundation
import Combine



class NetworkManager {
    
    static let shared: NetworkManager = NetworkManager()
    private init() { }
    
    func getString(fromUrl url: String) -> AnyPublisher<String, Error> {
        guard let url = URL(string: url) else {
            let error = URLError(.badURL)
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        // URLSession without any decoding
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { result -> String in
                guard let stringResponse = String(data: result.data, encoding: .utf8) else {
                    throw URLError(.cannotParseResponse)
                }
                return stringResponse
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func jsonContents<T>(
        fromUrl url: String,
        as type: T.Type,
        decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<T, Error> where T:Decodable {
        guard let url = URL(string: url) else {
            let error = URLError(.badURL, userInfo: [NSURLErrorKey: url])
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        // URLSession with no decoding stat as we had CodingKeys
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { result -> T in
                return try decoder.decode(type.self, from: result.data)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func jsonContentsWithRequest<T: Decodable, U: Encodable>(
        fromUrl url: String,
        as type: T.Type,
        message: U,
        decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<T, Error> {
        // Ensure the URL is valid
        guard let url = URL(string: url) else {
            let error = URLError(.badURL)
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Bypass NGROK Blocker Site
        request.setValue("69420", forHTTPHeaderField: "ngrok-skip-browser-warning")

        request.httpMethod = "POST"
        
        let encoder = JSONEncoder()
        // Safely encode the message, returning failure on error
        guard let data = try? encoder.encode(message) else {
            let encodingError = URLError(.cancelled)
            return Fail(error: encodingError).eraseToAnyPublisher()
        }
        
        request.httpBody = data

        // Perform the data task
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> T in
                // Ensure a valid HTTP response (status code 200-299)
                guard let httpResponse = result.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                // Try decoding the response
                return try decoder.decode(type.self, from: result.data)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
