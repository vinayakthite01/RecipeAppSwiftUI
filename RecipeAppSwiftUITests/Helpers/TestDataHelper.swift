//
//  TestDataHelper.swift
//  RecipeAppSwiftUITests
//
//  Created by Vinayak Thite on 05/12/24.
//

import Foundation
@testable import RecipeAppSwiftUI

struct TestDataHelper {
    static func getAllCategories() -> CategoriesModel {
        let fileName = "categoryResponse"
        let path = Bundle(for: APIServiceTests.self).path(forResource: fileName, ofType: "json")
        guard let path = path else {
            return CategoriesModel(categories: [
                Category(
                    idCategory: "12",
                    strCategory: "Vegetarian",
                    strCategoryThumb: "https://www.themealdb.com/images/category/vegetarian.png",
                    strCategoryDescription: "Vegetarianism is the practice of abstaining from the consumption of meat (red meat, poultry, seafood, and the flesh of any other animal), and may also include abstention from by-products of animal slaughter.\r\n\r\nVegetarianism may be adopted for various reasons. Many people object to eating meat out of respect for sentient life. Such ethical motivations have been codified under various religious beliefs, as well as animal rights advocacy. Other motivations for vegetarianism are health-related, political, environmental, cultural, aesthetic, economic, or personal preference. There are variations of the diet as well: an ovo-lacto vegetarian diet includes both eggs and dairy products, an ovo-vegetarian diet includes eggs but not dairy products, and a lacto-vegetarian diet includes dairy products but not eggs. A vegan diet excludes all animal products, including eggs and dairy. Some vegans also avoid other animal products such as beeswax, leather or silk clothing, and goose-fat shoe polish."
                ),
                Category(
                    idCategory: "13",
                    strCategory: "Breakfast",
                    strCategoryThumb: "https://www.themealdb.com/images/category/breakfast.png",
                    strCategoryDescription: "Breakfast is the first meal of a day. The word in English refers to breaking the fasting period of the previous night. There is a strong likelihood for one or more \"typical\", or \"traditional\", breakfast menus to exist in most places, but their composition varies widely from place to place, and has varied over time, so that globally a very wide range of preparations and ingredients are now associated with breakfast."
                )
                
            ])
        }
        let urlPath = URL(string: path)
        let data = try! Data(contentsOf: urlPath!)
        return try! JSONDecoder().decode(CategoriesModel.self, from: data)
    }
    
    static func getRecipeList() -> RecipesListModel {
        let fileName = "categoryResponse"
        let path = Bundle(for: APIServiceTests.self).path(forResource: fileName, ofType: "json")!
        let urlPath = URL(string: path)
        let data = try! Data(contentsOf: urlPath!)
        return try! JSONDecoder().decode(RecipesListModel.self, from: data)
    }
    
    static func getRecipeDetails() -> RecipeDetailModel {
        let fileName = "categoryResponse"
        let path = Bundle(for: APIServiceTests.self).path(forResource: fileName, ofType: "json")!
        let urlPath = URL(string: path)
        let data = try! Data(contentsOf: urlPath!)
        return try! JSONDecoder().decode(RecipeDetailModel.self, from: data)
    }
}
