//
//  RecipeDetailViewModel.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 04/12/24.
//

import Foundation
import Combine

// MARK: - Recipe Detail ViewModel
class RecipeDetailViewModel: ObservableObject {
    @Published var recipeDetail: RecipeDetail?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private var apiService = APIService()

    func fetchRecipeDetail(for id: String) {
        isLoading = true
        errorMessage = nil
        
        apiService.fetchRecipe(recipeId: id)
            .sink { completion in
                switch completion {
                case .failure(let apiError):
                    self.errorMessage = apiError.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: {[weak self] recipeDetails in
                Logger.log("RecipeDetail: \(recipeDetails)")
            }
            .store(in: &cancellables)

    }
}
