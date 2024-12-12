//
//  CategoriesView.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 03/12/24.
//

import SwiftUI

// MARK: - Categories View
struct CategoriesView: View {
    @ObservedObject var viewModel: CategoriesViewModel
//    @StateObject var coordinator = CategoryCoordinator()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                } else {
//                    NavigationStack(path: $coordinator.path) {
//                        List(viewModel.categories) { category in
//                            Button(action: {
//                                coordinator.navigateToRecipeList(for: category.strCategory)
//                            }) {
//                                Text(category.strCategory)
//                            }
//                        }
//                        .navigationTitle("Categories")
//                        .onAppear {
//                            viewModel.fetchCategories()
//                        }
//                        .alert(item: $viewModel.error) { error in
//                            Alert(title: Text("Error"), message: Text(error), dismissButton: .default(Text("OK")))
//                        }
//                        .navigationDestination(for: CategoryDestination.self) { destination in
//                            switch destination {
//                            case .recipeList(let category):
//                                let viewModel = RecipeListViewModel(category: category)
//                                RecipeListView(viewModel: viewModel)
//                            }
//                        }
//                    }
                    List(viewModel.categories) { category in
                        NavigationLink(destination: RecipeListView(category: category.strCategory)) {
                            HStack {
                                AsyncImage(url: URL(string: category.strCategoryThumb)) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())

                                VStack(alignment: .leading) {
                                    Text(category.strCategory)
                                        .font(.headline)
                                    Text(category.strCategoryDescription)
                                        .font(.subheadline)
                                        .lineLimit(2)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Categories")
            .onAppear {
                viewModel.fetchCategories()
            }
        }
    }
}
//
//extension CategoriesView {
//    init(viewModel: CategoriesViewModel) {
//        self.viewModel = viewModel
//    }
//}

//#Preview {
//}
