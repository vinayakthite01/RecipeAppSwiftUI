//
//  CategoriesView.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 03/12/24.
//

import SwiftUI

// MARK: - Categories View
struct CategoriesView: View {
    let dependencyContainer: DependencyContainerProtocol
    @ObservedObject var viewModel: CategoriesViewModel
    @State private var navigationPath = NavigationPath()

    init(dependencyContainer: DependencyContainerProtocol) {
        self.dependencyContainer = dependencyContainer
        self.viewModel = CategoriesViewModel(apiService: dependencyContainer.apiService)
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    List(viewModel.categories) { category in
                        HStack {
                            AsyncImage(url: URL(string: category.strCategoryThumb)) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                            } placeholder: {
                                ProgressView()
                            }
                            Text(category.strCategory)
                        }
                        .onTapGesture {
                            navigationPath.append(category)
                        }
                    }
                    .navigationTitle("Categories")
                }
            }
            .onAppear {
                viewModel.fetchCategories()
            }
            .navigationDestination(for: Category.self) { category in
                RecipeListView(dependencyContainer: dependencyContainer, category: category.strCategory)
            }
        }
    }
}
