//
//  DirectURLRouter.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 04/12/24.
//

import Foundation
import Combine

final class DirectURLRouter<EndPoint: EndPointType> {

    @Published var isConnected: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        NetworkMonitor.shared.isConnectedPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$isConnected)
    }
    
    /// Request a network call and return a Publisher
    func request<T: Decodable>(_ route: EndPoint, decode: @escaping (Decodable) -> T?) -> AnyPublisher<T, APIError> {
        
        // Check if network is connected
        if !isConnected {
            return Fail(error: .unreachable).eraseToAnyPublisher()
        }
        
        // Build URLRequest
        guard let url = URL(string: route.path) else {
            return Fail(error: .somethingWentWrong).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = route.httpMethod.rawValue
        
        Logger.log("Request URL: \(urlRequest.url!.absoluteString)")
        
        // Create Publisher using URLSession
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.requestFailed(description: "Invalid Response")
                }
                
                // Handle specific HTTP status codes
                switch httpResponse.statusCode {
                case 401:
                    throw APIError.unauthorised
                default:
                    break
                }
                
                Logger.logResponse(data, url: urlRequest.url!, code: httpResponse.statusCode)
                return data
            }
            .tryMap { data -> T in
                // Decode the data using the provided `decode` closure
                if let decodedObject = decode(data) {
                    return decodedObject
                } else {
                    throw APIError.jsonDecodingFailure
                }
            }
            .mapError { error in
                // Map errors to APIError type
                if let apiError = error as? APIError {
                    return apiError
                } else {
                    return APIError.somethingWentWrong
                }
            }
            .eraseToAnyPublisher()
    }
}
