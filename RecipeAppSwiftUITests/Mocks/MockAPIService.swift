//
//  MockAPIService.swift
//  RecipeAppSwiftUITests
//
//  Created by Vinayak Thite on 05/12/24.
//

import Foundation
import Combine
@testable import RecipeAppSwiftUI

class MockAPIService: APIServiceProtocol {
    var categoriesResult: Result<[RecipeAppSwiftUI.Category], APIError> = .success([])
    var recipesListResult: Result<[Recipe], APIError> = .success([])
    var recipeDetailsResult: Result<[RecipeDetail], APIError> = .success([])

//    override func fetchAllCategories() -> AnyPublisher<[RecipeAppSwiftUI.Category], APIError> {
//        return Future { promise in
//            promise(self.categoriesResult)
//        }
//        .eraseToAnyPublisher()
//    }
    
    override func fetchRecipes(category: String) -> AnyPublisher<[Recipe], APIError> {
        return Future { promise in
            promise(self.recipesListResult)
        }
        .eraseToAnyPublisher()
    }
    
    override func fetchRecipe(recipeId: String) -> AnyPublisher<[RecipeDetail], APIError> {
        return Future { promise in
            promise(self.recipeDetailsResult)
        }
        .eraseToAnyPublisher()
    }
}
