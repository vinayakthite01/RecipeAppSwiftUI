//
//  RecipeDetailView.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 04/12/24.
//

import SwiftUI

// MARK: - Recipe Detail View
struct RecipeDetailView: View {
    @ObservedObject var viewModel: RecipeDetailViewModel
//    @StateObject var coordinator = RecipeDetailsCoordinator()
    
//    let recipeID: String

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            } else if let recipeDetail = viewModel.recipeDetail {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        AsyncImage(url: URL(string: recipeDetail.strMealThumb)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(height: 200)
                        .cornerRadius(10)

                        Text(recipeDetail.strMeal)
                            .font(.title)
                            .bold()

                        Text("Category: \(recipeDetail.strCategory)")
                            .font(.subheadline)

                        Text("Cuisine: \(recipeDetail.strArea)")
                            .font(.subheadline)
                        
                        if let tags = recipeDetail.strTags {
                            Text("Tags: \(tags)")
                                .font(.subheadline)
                        }

                        Divider()

                        Text("Instructions")
                            .font(.headline)

                        Text(recipeDetail.strInstructions)
                            .font(.body)

                        if let youtubeLink = recipeDetail.strYoutube, !youtubeLink.isEmpty {
                            Divider()
                            Link("Watch on YouTube", destination: URL(string: youtubeLink)!)
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                }
            } else {
                Text("No data available.")
            }
        }
        .navigationTitle("Recipe Details")
        .onAppear {
//            viewModel.fetchRecipeDetail(for: recipeID)
        }
    }
}

//#Preview {
//    RecipeDetailView()
//}