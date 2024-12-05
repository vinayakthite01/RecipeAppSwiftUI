//
//  RecipeListView.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 04/12/24.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    let category: String

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            } else {
                List(viewModel.recipes) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipeID: recipe.idMeal)) {
                        HStack {
                            AsyncImage(url: URL(string: recipe.strMealThumb)) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())

                            Text(recipe.strMeal)
                                .font(.headline)
                        }
                    }
                }
            }
        }
        .navigationTitle("\(category) Recipes")
        .onAppear {
            viewModel.fetchRecipes(for: category)
        }
    }
}

#Preview {
    CategoriesView()
}
