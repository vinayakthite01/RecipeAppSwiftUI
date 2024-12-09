//
//  RecipeListViewModel.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 04/12/24.
//

import Foundation
import Combine

class RecipeListViewModel: ObservableObject {
    // MARK: - Properties
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let apiService = APIService()

    // MARK: - functions
    
    /// Fetch Recipe List for the category
    /// - Parameter category: category name
    func fetchRecipes(for category: String) {
        isLoading = true
        errorMessage = nil

        apiService.fetchRecipes(category: category)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let apiError):
                    self?.errorMessage = apiError.description
                }
            } receiveValue: { [weak self] recipes in
                self?.recipes = recipes
            }
            .store(in: &cancellables)
    }
}
