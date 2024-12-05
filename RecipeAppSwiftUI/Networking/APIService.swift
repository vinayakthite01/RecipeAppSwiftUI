//
//  APIService.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 04/12/24.
//

import Foundation
import Combine

// MARK: - NetworkManager
class APIService1 {
    static let shared = APIService() // Singleton instance
    private init() {}

    func fetch<T: Decodable>(_ url: URL, type: T.Type) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

class APIService {
    // Router to call baseURL APIs
    private let recipeRouter: Router<RecipeEndpoint>
    private let directURLRouter: DirectURLRouter<RecipeEndpoint>
    private var cancellables = Set<AnyCancellable>()
    
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
    
}

