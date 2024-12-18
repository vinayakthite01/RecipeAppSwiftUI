//
//  APIService.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 04/12/24.
//

import Foundation
import Combine

/// API Service Protocol
protocol APIServiceProtocol {
    
    /// Fetch all categories
    /// - Returns: Categories Array or Error
    func fetchAllCategories()  -> AnyPublisher<[Category], APIError>
    
    /// Fetch all recipes by its category
    /// - Parameter category: category name
    /// - Returns: List of Recipes or Error
    func fetchRecipes(category: String) -> AnyPublisher<[Recipe], APIError>
    
    /// Fetch all recipes by its recipe id
    /// - Parameter recipeId: recipe id
    /// - Returns: Recipe Details or Error
    func fetchRecipe(recipeId: String) -> AnyPublisher<[RecipeDetail], APIError>
    
    /// Search Recipe by query
    /// - Parameter query: query
    /// - Returns: List of Recipes or Error
    func searchRecipe(query: String) -> AnyPublisher<[RecipeDetail], APIError>
}

class APIService: APIServiceProtocol {
    // MARK: - Properties
    private let recipeRouter: Router<RecipeEndpoint>
    private let directURLRouter: DirectURLRouter<RecipeEndpoint>
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init() {
        self.recipeRouter = Router<RecipeEndpoint>()
        self.directURLRouter = DirectURLRouter<RecipeEndpoint>()
    }
    
    func fetchAllCategories()  -> AnyPublisher<[Category], APIError> {
        recipeRouter.request(.getCategories, responseType: CategoriesModel.self)
            .map(\.categories)
            .eraseToAnyPublisher()
    }
    
    func fetchRecipes(category: String) -> AnyPublisher<[Recipe], APIError> {
        directURLRouter.request(.getRecipeList(category: category), responseType: RecipesListModel.self)
            .map(\.meals)
            .eraseToAnyPublisher()
    }
    
    func fetchRecipe(recipeId: String) -> AnyPublisher<[RecipeDetail], APIError> {
        directURLRouter.request(.getRecipeDetail(recipeId: recipeId), responseType: RecipeDetailModel.self)
            .map(\.meals)
            .eraseToAnyPublisher()
    }
    
    func searchRecipe(query: String) -> AnyPublisher<[RecipeDetail], APIError> {
        directURLRouter.request(.searchRecipe(query: query), responseType: RecipeDetailModel.self)
            .map(\.meals)
            .eraseToAnyPublisher()
    }
}
