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
    var apiService = APIService()

    func fetchRecipeDetail(for id: String) {
        isLoading = true
        errorMessage = nil
        
        apiService.fetchRecipe(recipeId: id)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let apiError):
                    self?.errorMessage = apiError.description
                case .finished:
                    break
                }
            } receiveValue: { [weak self] recipeDetails in
                Logger.log("RecipeDetail: \(recipeDetails)")
                self?.recipeDetail = recipeDetails.first
            }
            .store(in: &cancellables)
    }
}
