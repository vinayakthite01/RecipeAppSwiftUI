//
//  RecipeListViewModelTests.swift
//  RecipeAppSwiftUITests
//
//  Created by Vinayak Thite on 06/12/24.
//

import XCTest
import Combine
@testable import RecipeAppSwiftUI

class RecipeListViewModelTests: XCTestCase {
    var viewModel: RecipeListViewModel!
    var mockAPIService: MockAPIService!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        viewModel = RecipeListViewModel()
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchRecipes_success() {
        let expectation = XCTestExpectation(description: "Fetch recipes successfully")
        let mockRecipes = [
            Recipe(
                idMeal: "52807",
                strMeal: "Baingan Bharta",
                strMealThumb: "https://www.themealdb.com/images/media/meals/urtpqw1487341253.jpg"
            ),
            Recipe(
                idMeal: "53078",
                strMeal: "Beetroot Soup (Borscht)",
                strMealThumb: "https://www.themealdb.com/images/media/meals/zadvgb1699012544.jpg"
            )
        ]
        
        mockAPIService.recipesListResult = .success([
            Recipe(
                idMeal: "52807",
                strMeal: "Baingan Bharta",
                strMealThumb: "https://www.themealdb.com/images/media/meals/urtpqw1487341253.jpg"
            ),
            Recipe(
                idMeal: "53078",
                strMeal: "Beetroot Soup (Borscht)",
                strMealThumb: "https://www.themealdb.com/images/media/meals/zadvgb1699012544.jpg"
            )
        ])

        mockAPIService.fetchRecipes(category: "Vegetarian")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Request failed with error: \(error)")
                }
            }, receiveValue: { recipes in
                XCTAssertEqual(recipes, mockRecipes)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        viewModel.fetchRecipes(for: "Test Category")

        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchRecipes_failure(){
        let expectation = XCTestExpectation(description: "Fetch all categories failure")

        let mockAPIService = MockAPIService()
        mockAPIService.recipesListResult = .failure(APIError.somethingWentWrong)

        mockAPIService.fetchRecipes(category: "Dessert")
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

    func testFetchRecipesList_loadingState() {
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

        viewModel.fetchRecipes(for: "Dessert")

        // Then
        wait(for: [expectation], timeout: 1.0)
    }
}
