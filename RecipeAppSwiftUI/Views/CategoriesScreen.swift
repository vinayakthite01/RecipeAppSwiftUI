//
//  Categories.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 03/12/24.
//

import SwiftUI

struct CategoriesScreen: View {
    @StateObject private var viewModel = CategoriesViewModel()

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
                    List(viewModel.categories) { category in
                        HStack {
                            AsyncImage(url: URL(string: category.strCategoryThumb)) { image in
                                image.resizable()
                                     .scaledToFill()
                                     .frame(width: 60, height: 60)
                                     .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }

                            VStack(alignment: .leading) {
                                Text(category.strCategory)
                                    .font(.headline)
                                Text(category.strCategoryDescription)
                                    .font(.subheadline)
                                    .lineLimit(2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Meal Categories")
            .onAppear {
                viewModel.fetchCategories()
            }
        }
    }
}

#Preview {
    CategoriesScreen()
}
