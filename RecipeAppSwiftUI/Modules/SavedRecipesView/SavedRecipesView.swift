//
//  SavedRecipesView.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 10/12/24.
//

import SwiftUI

import SwiftUI

struct SavedRecipesView: View {
    let dependencyContainer: DependencyContainerProtocol
    @ObservedObject var viewModel: SavedRecipesViewModel

    init(dependencyContainer: DependencyContainerProtocol) {
        self.dependencyContainer = dependencyContainer
        self.viewModel = SavedRecipesViewModel(coredataService: dependencyContainer.coredataService)
    }

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                } else {
                    List(viewModel.recipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(dependencyContainer: dependencyContainer, recipeID: recipe.idMeal)) {
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
                    .navigationTitle("Saved Recipes")
                }
            }
            .onAppear {
                viewModel.fetchSavedRecipes()
            }
        }
    }
}
