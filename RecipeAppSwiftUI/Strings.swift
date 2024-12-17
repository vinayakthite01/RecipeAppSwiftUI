//
//  Strings.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 12/12/24.
//

import Foundation

enum Strings {
    static let home = "Tabbar.home.title".localizedUppercase
    static let search = "Tabbar.search.title".localizedUppercase
    static let favorites = "Tabbar.favorites.title".localizedUppercase
    static let settings = "Tabbar.settings.title".localizedUppercase
}

extension String {
    enum Common {
        static let noDataAvailable = "Common.noDataAvailable".localizedUppercase
        static let loading = "Common.loading".localizedUppercase
    }
}

extension String {
    enum Search {
        static let title = "Search.title".localizedUppercase
        static let placeholder = "Search.placeholder".localizedUppercase
    }
}

extension Strings {
    enum Categories {
        static let title = "Categories.title".localizedUppercase
    }
}

extension Strings {
    enum RecipeList {
        static let title = "RecipeList.title".localizedUppercase
    }
}

extension String {
    enum Recipe {
        static let title = "Recipe.title".localizedUppercase
        static let category = "Recipe.category".localizedUppercase
        static let cuisine = "Recipe.cuisine".localizedUppercase
        static let tags = "Recipe.tags".localizedUppercase
        static let instructions = "Recipe.instructions".localizedUppercase
        static let watchOnYouTube = "Recipe.watchOnYouTube".localizedUppercase
    }
}
