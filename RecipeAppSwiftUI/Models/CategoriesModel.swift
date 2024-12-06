//
//  CategoriesModel.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 03/12/24.
//

import Foundation

struct CategoriesModel: Codable {
    let categories: [Category]
}

struct Category: Codable, Identifiable, Equatable {
    let idCategory: String
    let strCategory: String
    let strCategoryThumb: String
    let strCategoryDescription: String
    
    var id: String { idCategory }
}
