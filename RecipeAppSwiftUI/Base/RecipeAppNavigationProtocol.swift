//
//  RecipeAppNavigationProtocol.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 10/12/24.
//

import Foundation
import SwiftUI
import Combine

enum NavigationDestinations: Hashable, View {
    
    case category
    case RecipeList(categoryName: String)
    case RecipeDetails(recipeId: String)
    
    var body: some View {
        switch self {
        case .category:
            CategoriesView(dependencyContainer: DependencyContainer())
        case .RecipeList(categoryName: let categoryName):
            RecipeListView(dependencyContainer: DependencyContainer(), category: categoryName)
        case .RecipeDetails(recipeId: let recipeId):
            RecipeDetailView(dependencyContainer: DependencyContainer(), recipeID: recipeId)
        }
    }
}
