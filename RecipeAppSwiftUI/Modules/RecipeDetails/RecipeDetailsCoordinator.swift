//
//  RecipeDetailsCoordinator.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 11/12/24.
//

import Foundation
import SwiftUI

// MARK: - Enum for navigation destinations
enum RecipeDetailDestination: Hashable {
    case recipeDetails(String)
}

struct RecipeDetailsCoordinator {
    @ObservableObject var path = NavigationPath()

}
