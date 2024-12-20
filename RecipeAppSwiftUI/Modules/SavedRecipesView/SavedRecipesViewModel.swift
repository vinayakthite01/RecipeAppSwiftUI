//
//  SavedRecipesViewModel.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 20/12/24.
//

import Foundation
import Combine

class SavedRecipesViewModel: ObservableObject {
    // MARK: - Properties
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let coredataService: CoreDataServiceProtocol
    
    init(coredataService: CoreDataServiceProtocol) {
        self.coredataService = coredataService
    }

    // MARK: - functions
    
    /// Fetch Recipe List for the category
    /// - Parameter category: category name
    func fetchSavedRecipes() {
        isLoading = true
        errorMessage = nil

        coredataService.fetchSavedRecipes()
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] recipes in
                Logger.log("Recipes fetched: \(recipes)")
                self?.recipes = recipes
                if recipes.isEmpty {
                    self?.errorMessage = "No saved recipes found!"
                } else {
                    self?.recipes.sort { $0.id > $1.id }
                }
            }
    }
}
