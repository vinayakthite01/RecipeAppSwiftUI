//
//  MockURLProtocols.swift
//  RecipeAppSwiftUITests
//
//  Created by Vinayak Thite on 05/12/24.
//

import Foundation
@testable import RecipeAppSwiftUI

class MockURLProtocol: URLProtocol {
    static var responseData: Data?
    static var responseStatusCode: Int = 200

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let responseData = MockURLProtocol.responseData {
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: MockURLProtocol.responseStatusCode,
                httpVersion: nil,
                headerFields: nil
            )!
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: responseData)
        } else {
            client?.urlProtocol(self, didFailWithError: APIError.somethingWentWrong)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
