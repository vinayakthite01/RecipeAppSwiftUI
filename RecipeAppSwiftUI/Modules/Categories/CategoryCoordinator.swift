//
//  CategoryCoordinator.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 11/12/24.
//

import Foundation
import SwiftUI

// MARK: - Enum for navigation destinations
enum CategoryDestination: Hashable {
    case recipeList(String)
}

//MARK: - Coordinator as an ObservableObject
struct CategoryCoordinator {
    @ObservableObject var path = NavigationPath()
    
    mutating func navigateToRecipeList(for category: String) {
        path.append(CategoryDestination.recipeList(category))
    }
}
