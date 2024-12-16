//
//  RecipeBuilder.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 06/12/24.
//

import Foundation
import SwiftUI

// MARK: - RecipeBuilder
struct RecipeListBuilder {
    private let apiService: APIServiceProtocol
    private let category: String?
    
    init(apiService: APIServiceProtocol, category: String?) {
        self.apiService = apiService
        self.category = category
    }
    
    func buildRecipeList() -> some View {
        let viewModel = RecipeListViewModel(apiService: self.apiService)
        return RecipeListView(viewModel: viewModel, category: self.category)
    }
}
