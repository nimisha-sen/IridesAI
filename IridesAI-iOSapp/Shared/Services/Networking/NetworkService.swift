//
//  NetworkService.swift
//  Lamei
//
//  Created by Siddharth S on 07/09/24.
//

import Foundation
import Combine

class LameiNetworkService {
    
    let baseUrl = "https://harmless-stud-gently.ngrok-free.app"
    let jsonDecoder: JSONDecoder
    
    init() {
        // Create snakeCase jsonDecoder
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        self.jsonDecoder = jsonDecoder
    }
    
    func getStatus() -> AnyPublisher<String, Error> {
        NetworkManager.shared.getString(fromUrl: baseUrl + LameiAPIRoutes.Status.route)
            .mapError { error -> Error in
                return error
            }
            .eraseToAnyPublisher()
    }
    
    func getMessageResponse(request: Prompt.Request) -> AnyPublisher<Prompt.Response, Error> {
        NetworkManager.shared.jsonContentsWithRequest(fromUrl: baseUrl + LameiAPIRoutes.Prompt.route, as: Prompt.Response.self, message: request, decoder: jsonDecoder)
            .mapError { error -> Error in
                return error
            }
            .eraseToAnyPublisher()
    }
}

enum LameiAPIRoutes {
    case Status
    case Prompt
    
    var route: String {
        switch self {
            case .Status: ""
            case .Prompt: "/api/chat"
        }
    }
}

