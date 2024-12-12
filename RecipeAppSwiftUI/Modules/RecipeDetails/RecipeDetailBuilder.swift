//
//  RecipeBuilder.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 06/12/24.
//

import Foundation
import SwiftUI

// MARK: - Recipe Builder
struct RecipeBuilder {
    private let apiService: APIServiceProtocol
    private let recipeId: String
    
    init(apiService: APIServiceProtocol, recipeId: String) {
        self.apiService = apiService
    }
    
    func buildRecipeDetail() -> some View {
        let viewModel = RecipeDetailViewModel(apiService: apiService)
        viewModel.fetchRecipeDetail(for: recipeId)
        return RecipeDetailView(viewModel: viewModel)
    }
}
