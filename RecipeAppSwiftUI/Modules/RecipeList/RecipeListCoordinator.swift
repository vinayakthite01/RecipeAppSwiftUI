//
//  RecipeListCoordinator.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 11/12/24.
//

import Foundation
import SwiftUI

// MARK: - Enum for navigation destinations
enum RecipeListDestination: Hashable {
    case recipeDetails(String)
}

//MARK: - Coordinator as an ObservableObject
struct RecipeListCoordinator {
    @ObservableObject var path = NavigationPath()
    
    mutating func navigateToRecipeDetails(for recipeId: String) {
        path.append(RecipeListDestination.recipeDetails(recipeId))
    }
}
