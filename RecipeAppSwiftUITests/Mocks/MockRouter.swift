//
//  MockRouter.swift
//  RecipeAppSwiftUITests
//
//  Created by Vinayak Thite on 05/12/24.
//

import Combine
import XCTest
@testable import RecipeAppSwiftUI

class MockRouter<EndPoint: EndPointType>: Router<EndPoint> {
    var mockResult: AnyPublisher<Decodable, APIError>?
    
    override func request<T: Decodable>(_ route: EndPoint, responseType: T.Type) -> AnyPublisher<T, APIError> {
        guard let mockResult = mockResult else {
            return Fail(error: APIError.somethingWentWrong).eraseToAnyPublisher()
        }
        return mockResult
            .tryMap { decodable in
                guard let result = decodable as? T else {
                    throw APIError.jsonDecodingFailure
                }
                return result
            }
            .mapError { $0 as? APIError ?? APIError.somethingWentWrong }
            .eraseToAnyPublisher()
    }
}
