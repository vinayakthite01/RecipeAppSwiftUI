//
//  NetworkManager.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 04/12/24.
//

import Foundation
import Combine

final class Router<EndPoint: EndPointType> {

    @Published var isConnected: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        NetworkMonitor.shared.isConnectedPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$isConnected)
    }
    
    /// Reactive API Request
    /// - Parameters:
    ///   - route: End Point
    ///   - type: Decodable model type
    /// - Returns: A publisher that emits the decoded model or an APIError
    func request<T: Decodable>(_ route: EndPoint, responseType: T.Type) -> AnyPublisher<T, APIError> {
        // Check if network is connected
        if !isConnected {
            return Fail(error: .unreachable).eraseToAnyPublisher()
        }
        
        var components = URLComponents()
        components.scheme = route.scheme
        components.host = route.baseURL
        components.path = route.path
        components.queryItems = route.parameters
        
        guard let url = components.url else {
            return Fail(error: APIError.somethingWentWrong)
                .eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = route.httpMethod.rawValue
        urlRequest.httpBody = route.data
        
        let headers = route.headers ?? []
        headers.forEach { urlRequest.addValue($0.header.value, forHTTPHeaderField: $0.header.field) }
        
        Logger.log(curl: urlRequest)
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response -> T in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.requestFailed(description: "Invalid Response")
                }
                
                if httpResponse.statusCode == 401 {
                    throw APIError.unauthorised
                }
                
                if httpResponse.statusCode == 202 {
                    throw APIError.accepted
                }
                
                if httpResponse.statusCode == 204 {
                    throw APIError.noContent
                }
                
                Logger.logResponse(data, url: urlRequest.url!, code: httpResponse.statusCode)
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(.iso8601Full)
                    return try decoder.decode(T.self, from: data)
                } catch {
                    throw APIError.jsonDecodingFailure
                }
            }
            .mapError { error -> APIError in
                if let apiError = error as? APIError {
                    return apiError
                }
                return .responseUnsuccessful(description: error.localizedDescription)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
