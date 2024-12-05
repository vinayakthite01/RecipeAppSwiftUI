//
//  RecipeDetailModel.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 04/12/24.
//

import Foundation

// MARK: - Recipe Detail Model
struct RecipeDetailModel: Codable {
    let meals: [RecipeDetail]
}

struct RecipeDetail: Codable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strCategory: String
    let strArea: String
    let strInstructions: String
    let strMealThumb: String
    let strYoutube: String?

    var id: String { idMeal }
}

