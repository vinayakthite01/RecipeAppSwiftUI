//
//  SearchView.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 10/12/24.
//

import SwiftUI

struct SearchView: View {
    let dependencyContainer: DependencyContainerProtocol
    @ObservedObject var viewModel: SearchViewModel

    init(dependencyContainer: DependencyContainerProtocol) {
        self.dependencyContainer = dependencyContainer
        self.viewModel = SearchViewModel(apiService: dependencyContainer.apiService)
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    // Search Field
                    TextField("Search for meals", text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    // Search Button
                    Image(systemName: "magnifyingglass")
                        .font(.title)
                        .foregroundColor(.secondary)
                        .padding(.trailing)
                }
        
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    if let recipes = viewModel.recipes {
                        List(recipes) { recipe in
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
                    } else {
                        Text("No meals found")
                    }
                }
            }
            .navigationTitle("Search Meals")
        }
    }
}

#Preview {
    SearchView(dependencyContainer: DependencyContainer())
}
