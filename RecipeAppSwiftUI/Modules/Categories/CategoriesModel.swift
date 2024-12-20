//
//  CategoriesModel.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 03/12/24.
//

import Foundation
// MARK: - Category Model
struct CategoriesModel: Decodable {
    let categories: [Category]
}
// MARK: - Categories
struct Category: Decodable, Hashable, Identifiable, Equatable {
    let idCategory: String
    let strCategory: String
    let strCategoryThumb: String
    let strCategoryDescription: String
    
    var id: String { idCategory }
}
