//
//  RecipeDetailsViewModelTests.swift
//  RecipeAppSwiftUITests
//
//  Created by Vinayak Thite on 06/12/24.
//

import XCTest
import Combine
@testable import RecipeAppSwiftUI

final class RecipeDetailsViewModelTests: XCTestCase {

    var viewModel: CategoriesViewModel!
    var mockAPIService: MockAPIService!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        viewModel = CategoriesViewModel()
        viewModel.apiService = MockAPIService() // Inject mock API service
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        viewModel = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    func testFetchCategories_loadingState() {
        // Given
        mockAPIService.categoriesResult = .success([])

        let expectation = XCTestExpectation(description: "Verify loading state transitions")
        var loadingStates: [Bool] = []

        // When
        viewModel.$isLoading
            .sink { isLoading in
                loadingStates.append(isLoading)
                if loadingStates.count == 2 { // Initial and post-loading state
                    XCTAssertEqual(loadingStates, [false, true], "Loading states should transition from false to true")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.fetchCategories()

        // Then
        wait(for: [expectation], timeout: 1.0)
    }
}
