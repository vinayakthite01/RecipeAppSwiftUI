//
//  RecipeDetailModel.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 04/12/24.
//

import Foundation

// MARK: - Recipe Detail Model
struct RecipeDetailModel: Decodable {
    let meals: [RecipeDetail]
}

// MARK: - Recipe Detail
struct RecipeDetail: Decodable, Identifiable, Equatable {
    let idMeal: String
    let strMeal: String
    let strCategory: String
    let strArea: String
    let strInstructions: String
    let strMealThumb: String
    let strTags: String?
    let strYoutube: String?

    var id: String { idMeal }
}

