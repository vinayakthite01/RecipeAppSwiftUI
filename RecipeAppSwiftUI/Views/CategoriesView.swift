//
//  CategoriesView.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 03/12/24.
//

import SwiftUI

// MARK: - Categories View
struct CategoriesView: View {
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

#Preview {
    CategoriesView()
}
