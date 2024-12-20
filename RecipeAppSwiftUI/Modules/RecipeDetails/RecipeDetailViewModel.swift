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
    // MARK: - Properties    
    @Published var recipeDetail: RecipeDetail?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isLiked = false
    @Published var rating = 0

    private var cancellables = Set<AnyCancellable>()
    private let apiService: APIServiceProtocol
    private let coredataService: CoreDataServiceProtocol
    
    init(apiService: APIServiceProtocol, coredataService: CoreDataServiceProtocol) {
        self.apiService = apiService
        self.coredataService = coredataService
    }

    // MARK: - Functions
    
    /// Fetch Recipes detail
    /// - Parameter id: id of the recipe
    func fetchRecipeDetail(for id: String) {
        isLoading = true
        errorMessage = nil
        
        apiService.fetchRecipe(recipeId: id)
            .sink {[weak self] completion in
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
    
    /// Toggle with favorite button
    func toggleLike() {
        isLiked.toggle()
    }
    
    /// Save recipe as favorite
    func saveRecipeLocally() {
        guard let recipeDetail else { return }
        coredataService.saveRecipe(recipeDetail, rating: rating, isFavorite: isLiked)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case.failure(let error):
                    self?.errorMessage = error.localizedDescription
                case.finished:
                    break
                }
            } receiveValue: { _ in
                Logger.log("recipe saved successfully")
            }
            .store(in: &cancellables)
    }
}
