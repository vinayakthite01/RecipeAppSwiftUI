//
//  APIServiceTests.swift
//  RecipeAppSwiftUITests
//
//  Created by Vinayak Thite on 05/12/24.
//

import XCTest
import Combine
@testable import RecipeAppSwiftUI

class APIServiceTests: XCTestCase {
    var apiService: APIService!
    var mockRecipeRouter: MockRouter<RecipeEndpoint>!
    var mockDirectURLRouter: MockRouter<RecipeEndpoint>!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockRecipeRouter = MockRouter<RecipeEndpoint>()
        mockDirectURLRouter = MockRouter<RecipeEndpoint>()
        
        apiService = APIService()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        apiService = nil
        mockRecipeRouter = nil
        mockDirectURLRouter = nil
        super.tearDown()
    }

    func testFetchAllCategories_success() {
        // Given
        let categories = [Category(idCategory: "3", strCategory: "Dessert", strCategoryThumb: "", strCategoryDescription: "")]
        let mockCategoriesModel = CategoriesModel(categories: categories)
        mockRecipeRouter.mockResult = Just(mockCategoriesModel)
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()

        let expectation = XCTestExpectation(description: "Fetch categories successfully")

        // When
        apiService.fetchAllCategories()
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success, got failure")
                }
            }, receiveValue: { fetchedCategories in
                XCTAssertEqual(fetchedCategories.first?.strCategory, "Beef")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchAllCategories_failure() {
        // Given
        let mockAPIService = MockAPIService()
        mockAPIService.categoriesResult = .failure(APIError.responseUnsuccessful(description: "Bad Request"))

        let expectation = XCTestExpectation(description: "Fetch categories failure")

        // When
        mockAPIService.fetchAllCategories()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, .responseUnsuccessful(description: "Bad Request"))
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, got success")
            })
            .store(in: &cancellables)

        // Then
        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchRecipes_success() {
        // Given
        let recipes = [Recipe(idMeal: "1", strMeal: "Pasta", strMealThumb: "")]
        let mockRecipesListModel = RecipesListModel(meals: recipes)
        mockDirectURLRouter.mockResult = Just(mockRecipesListModel)
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()

        let expectation = XCTestExpectation(description: "Fetch recipes successfully")

        // When
        apiService.fetchRecipes(category: "Vegetarian")
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success, got failure")
                }
            }, receiveValue: { fetchedRecipes in
                XCTAssertEqual(fetchedRecipes.first?.strMeal, "Baingan Bharta")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        // Then
        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchRecipeDetail_success() {
        // Given
        let recipeDetails = [
            RecipeDetail(
                idMeal: "52807",
                strMeal: "Baingan Bharta",
                strCategory: "Vegetarian",
                strArea: "Indian",
                strInstructions: "Rinse the baingan (eggplant or aubergine) in water.",
                strMealThumb: "https://www.themealdb.com/images/media/meals/urtpqw1487341253.jpg",
                strTags: "Spicy,Bun,Calorific",
                strYoutube: "https://www.youtube.com/watch?v=-84Zz2EP4h4"
            )
        ]
        let mockRecipeDetailModel = RecipeDetailModel(meals: recipeDetails)
        mockDirectURLRouter.mockResult = Just(mockRecipeDetailModel)
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()

        let expectation = XCTestExpectation(description: "Fetch recipe detail successfully")

        // When
        apiService.fetchRecipe(recipeId: "52807")
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success, got failure")
                }
            }, receiveValue: { fetchedDetails in
                XCTAssertEqual(fetchedDetails.count, recipeDetails.count)
                XCTAssertEqual(fetchedDetails.first?.strMeal, "Baingan Bharta")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        // Then
        wait(for: [expectation], timeout: 1.0)
    }
}
