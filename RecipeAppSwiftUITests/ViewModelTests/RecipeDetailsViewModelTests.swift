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

    var viewModel: RecipeDetailViewModel!
    var mockAPIService: MockAPIService!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        viewModel = RecipeDetailViewModel()
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchRecipeDetailSuccess() {
        let expectation = XCTestExpectation(description: "Fetch recipe detail successfully")
        let mockRecipeDetail = RecipeDetail(
            idMeal: "52807",
            strMeal: "Baingan Bharta",
            strCategory: "Vegetarian",
            strArea: "Indian",
            strInstructions: "Rinse the baingan (eggplant or aubergine) in water...",
            strMealThumb: "https://www.themealdb.com/images/media/meals/urtpqw1487341253.jpg",
            strTags: "Spicy,Bun,Calorific",
            strYoutube: "https://www.youtube.com/watch?v=-84Zz2EP4h4"
        )
        
        mockAPIService.recipeDetailsResult = .success([mockRecipeDetail])
        
        viewModel.$recipeDetail
            .dropFirst()
            .sink { recipeDetail in
                XCTAssertEqual(recipeDetail?.strMeal, mockRecipeDetail.strMeal)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchRecipeDetail(for: "52807")
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchRecipes_failure(){
        let expectation = XCTestExpectation(description: "Fetch recipe detail failure")

        let mockAPIService = MockAPIService()
        mockAPIService.recipeDetailsResult = .failure(APIError.somethingWentWrong)

        mockAPIService.fetchRecipe(recipeId: "52807")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, APIError.somethingWentWrong)
                    expectation.fulfill()
                }
            }, receiveValue: { recipeDetail in
                XCTFail("Request should not succeed")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2.0)
    }

    func testFetchCategories_loadingState() {
        // Given
        mockAPIService.recipesListResult = .success([])

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

        viewModel.fetchRecipeDetail(for: "52807")

        // Then
        wait(for: [expectation], timeout: 1.0)
    }
}
