//
//  MockNetworkPathMonitor.swift
//  RecipeAppSwiftUITests
//
//  Created by Vinayak Thite on 05/12/24.
//

import Network
import Combine
import XCTest
@testable import RecipeAppSwiftUI

class MockResponse: Decodable {
    // Define the mock response properties
    let mockCategories = TestDataHelper.getAllCategories()
}

class NetworkMonitor {
    static let shared = NetworkMonitor()
    var isConnectedPublisher = PassthroughSubject<Bool, Never>()
}
