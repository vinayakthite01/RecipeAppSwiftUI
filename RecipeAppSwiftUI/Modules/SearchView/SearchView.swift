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
                TextField("Search for meals", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    if let recipes = viewModel.recipes {
                        List(recipes) { meal in
                            HStack {
                                AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                } placeholder: {
                                    ProgressView()
                                }
                                Text(meal.strMeal)
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
