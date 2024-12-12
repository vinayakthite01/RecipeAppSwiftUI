//
//  MockEndpoints.swift
//  RecipeAppSwiftUITests
//
//  Created by Vinayak Thite on 05/12/24.
//

import Foundation
@testable import RecipeAppSwiftUI

import Foundation

struct MockEndPoint: EndPointType {
    var scheme: String
    var baseURL: String
    var path: String
    var httpMethod: HTTPMethod
    var parameters: [URLQueryItem]?
    var headers: [HTTPHeader]?
    var data: Data?

    init(
        scheme: String = "https://",
        baseURL: String = "themealdb.com",
        path: String = "/api.php",
        httpMethod: HTTPMethod = .get,
        parameters: [URLQueryItem]? = nil,
        headers: [HTTPHeader]? = nil,
        data: Data? = nil
    ) {
        self.scheme = scheme
        self.baseURL = baseURL
        self.path = path
        self.httpMethod = httpMethod
        self.parameters = parameters
        self.headers = headers
        self.data = data
    }
}
