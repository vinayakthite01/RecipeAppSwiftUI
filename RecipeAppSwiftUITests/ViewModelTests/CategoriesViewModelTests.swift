//
//  CategoriesViewModelTests.swift
//  RecipeAppSwiftUITests
//
//  Created by Vinayak Thite on 03/12/24.
//

import XCTest
import Combine
@testable import RecipeAppSwiftUI

class CategoriesViewModelTests: XCTestCase {
    
    var viewModel: CategoriesViewModel!
    var mockAPIService: APIServiceProtocol?
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        viewModel = CategoriesViewModel()
        viewModel.apiService = mockAPIService // Inject mock API service
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        viewModel = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    func testFetchCategories_success() {
        let expectation = XCTestExpectation(description: "Fetch categories successfully")

        mockAPIService.categoriesResult = .success([RecipeAppSwiftUI.Category(
            idCategory: "3",
            strCategory: "Dessert",
            strCategoryThumb: "https://www.themealdb.com/images/category/dessert.png",
            strCategoryDescription: "Dessert is a course that concludes a meal. The course usually consists of sweet foods, such as confections dishes or fruit, and possibly a beverage such as dessert wine or liqueur, however in the United States it may include coffee, cheeses, nuts, or other savory items regarded as a separate course elsewhere. In some parts of the world, such as much of central and western Africa, and most parts of China, there is no tradition of a dessert course to conclude a meal.\r\n\r\nThe term dessert can apply to many confections, such as biscuits, cakes, cookies, custards, gelatins, ice creams, pastries, pies, puddings, and sweet soups, and tarts. Fruit is also commonly found in dessert courses because of its naturally occurring sweetness. Some cultures sweeten foods that are more commonly savory to create desserts."
        )])

        mockAPIService.fetchAllCategories()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Request failed with error: \(error)")
                }
            }, receiveValue: { categories in
                XCTAssertEqual(categories.count, 1)
                XCTAssertEqual(categories.first?.strCategory, "Dessert")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0) // Increased timeout to 5 seconds
    }
    
    func testFetchAllCategories_failure() {
        let expectation = XCTestExpectation(description: "Fetch all categories failure")

        mockAPIService.categoriesResult = .failure(APIError.somethingWentWrong)

        mockAPIService.fetchAllCategories()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, APIError.somethingWentWrong)
                    expectation.fulfill()
                }
            }, receiveValue: { categories in
                XCTFail("Request should not succeed")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2.0)
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
