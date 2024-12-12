//
//  Endpoints.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 04/12/24.
//

import Foundation

enum RecipeEndpoint {
    /// get recipe Category
    case getCategories
    
    /// get recipe list by Category
    case getRecipeList(category: String)
    
    /// get Recipe Detail
    case getRecipeDetail(recipeId: String)
}

extension RecipeEndpoint: EndPointType {
    var headers: [HTTPHeader]? {
        nil
    }
    
    /// scheme will be https
    var scheme: String { "https" }
    
    /// base URL
    var baseURL: String {
        return Environment.baseURL
    }

    /// path component
    var path: String {
        var finalPath = String()
        switch self {
        case .getCategories:
            finalPath = "/api/json/v1/1/categories.php"
        case .getRecipeList(let category):
            finalPath = "/api/json/v1/1/filter.php?c=\(category)"
        case .getRecipeDetail(let recipeId):
            finalPath = "/api/json/v1/1/lookup.php?i=\(recipeId)"
        }
        return  finalPath
    }
    
    /// request method type
    var httpMethod: HTTPMethod {
        switch self {
        case .getCategories, .getRecipeList, .getRecipeDetail:
            return .get
        }
    }
    
    /// parameters passing
    var parameters: [URLQueryItem]? { nil }
    
    /// data (body) passing as params
    var data: Data? {
        switch self {
        case .getCategories, .getRecipeList, .getRecipeDetail:
            return nil
        }
    }
}
