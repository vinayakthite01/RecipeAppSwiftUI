//
//  RecipeListModel.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 04/12/24.
//

import Foundation

// MARK: - Recipe Model
struct RecipesListModel: Decodable {
    let meals: [Recipe]
}
// MARK: - Recipe Model
struct Recipe: Decodable, Identifiable, Equatable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String

    var id: String { idMeal }
}
