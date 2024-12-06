//
//  DirectURLRounterTests.swift
//  RecipeAppSwiftUITests
//
//  Created by Vinayak Thite on 05/12/24.
//

import XCTest
import Combine
import Network
@testable import RecipeAppSwiftUI

final class DirectURLRouterTests: XCTestCase {

    var router: DirectURLRouter<MockEndPoint>!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        try super.setUpWithError()
        router = DirectURLRouter<MockEndPoint>()
        cancellables = []
    }

    override func tearDownWithError() throws {
        router = nil
        cancellables = nil
        try super.tearDownWithError()
    }

    // Test to check network connectivity updates
    func testNetworkConnectivityUpdates() {
        let expectation = XCTestExpectation(description: "Network connectivity updates")

        NetworkMonitor.shared.isConnectedPublisher.send(false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(self.router.isConnected)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    // Test to check if request fails when not connected
    func testRequestFailsWhenNotConnected() {
        let expectation = XCTestExpectation(description: "Request fails when not connected")

        NetworkMonitor.shared.isConnectedPublisher.send(false)
        let mockEndpoint = MockEndPoint()
        router.request(mockEndpoint, responseType: MockResponse.self)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, APIError.unreachable)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Request should not succeed")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2.0)
    }
}
