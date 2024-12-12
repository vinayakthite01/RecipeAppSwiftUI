//
//  ViewModels.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 03/12/24.
//

import Foundation
import SwiftUI
import Combine

class CategoriesViewModel: ObservableObject {
    // MARK: - Properties
    @Published var categories: [Category] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let apiService: APIServiceProtocol
    private var selectedCategory: String?
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    // MARK: - functions
    
    /// Fetch Categoeis
    func fetchCategories() {
        isLoading = true
        errorMessage = nil
        
        apiService.fetchAllCategories()
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let apiError):
                    self?.errorMessage = apiError.description
                }
            } receiveValue: { [weak self] categories in
                Logger.log("Category Response: \(categories)")
                self?.categories = categories
            }
            .store(in: &cancellables)
    }
    
    func selectedCategory(index: Int) {
        selectedCategory = categories[index].strCategory
    }
    
    var buildRecipeList: some View {
        let recipeListBuilder = RecipeListBuilder(apiService: apiService, category: selectedCategory)
        return recipeListBuilder.buildRecipeList()
    }
}
