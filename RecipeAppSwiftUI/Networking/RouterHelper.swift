//
//  NetworkHelper.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 04/12/24.
//

import Foundation

/// HTTP Headers
enum HTTPHeader {
    case content(String)
    case accept(String)
    case auth(String)
    case custom(String, String)
    
    var header: (field: String, value: String) {
        switch self {
        case .content(let value): return (field: "Content-Type", value: value)
        case .accept(let value): return (field: "Accept", value: value)
        case .auth(let value): return (field: "Authorization", value: "Bearer " + value)
        case .custom(let key, let value): return (field: key, value: value)
        }
    }
}

/// Request Method type
enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

/// EndPointType protocol
protocol EndPointType {
    /// scheme
    var scheme: String { get }
    
    /// base URL
    var baseURL: String { get }
    
    /// request path
    var path: String { get }
    
    /// request Method
    var httpMethod: HTTPMethod { get }
    
    /// API Params
    var parameters: [URLQueryItem]? { get }
    
    /// API header
    var headers: [HTTPHeader]? { get }
    
    /// Data
    var data: Data? { get }
}

/// API errors enum
enum APIError: Error, Equatable {
    case accepted
    case noContent
    case unauthorised
    case unreachable
    case somethingWentWrong
    case jsonDecodingFailure
    case responseUnsuccessful(description: String)
    case requestFailed(description: String)
    case custom(model: APIErrorResponseModel?)
    
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        lhs.description == rhs.description
    }
}

/// API errors enum extension
extension APIError: CustomStringConvertible {
    var customDescription: String {
        switch self {
        case .accepted: return "Your request is accepted"
        case .noContent: return "Your request is valid but server returned no data"
        case .unauthorised: return "Your session has been timed out. Please login again."
        case .unreachable: return "Please check your internet connectivity."
        case .somethingWentWrong: return "Something went wrong, Please try after sometime."
        case .jsonDecodingFailure: return "Unable to manage your response, Please try after sometime."
        case .responseUnsuccessful(let description): return description
        case .requestFailed(let description): return description
        case .custom(let model): return model?.error ?? ""
        }
    }
    
    var description: String { customDescription }
}

// MARK: APIResponseModel
/// Common API response model
struct APIResponseModel<T: Decodable>: Decodable {
    let data: T
}

// MARK: APIErrorResponseModel
/// Common API error response model
struct APIErrorResponseModel: Codable {
    let code: String
    let messages: [String]
    let requestId: String
    let status: Int
    
    var error: String {
        (code.isEmpty ? "" : (code  + ": ")) + (messages.first ?? "")
    }
}
