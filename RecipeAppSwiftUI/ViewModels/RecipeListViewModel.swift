//
//  RecipeListViewModel.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 04/12/24.
//

import Foundation
import Combine

class RecipeListViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let apiService = APIService()

    func fetchRecipes(for category: String) {
        isLoading = true
        errorMessage = nil

        apiService.fetchRecipes(category: category)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let apiError):
                    self.errorMessage = apiError.localizedDescription
                }
            } receiveValue: { [weak self] recipes in
                self?.recipes = recipes
            }

    }
}
