//
//  RecipeDetailView.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 04/12/24.
//

import SwiftUI

// MARK: - Recipe Detail View
struct RecipeDetailView: View {
    let dependencyContainer: DependencyContainerProtocol
    let recipeID: String
    @ObservedObject var viewModel: RecipeDetailViewModel

    init(
        dependencyContainer: DependencyContainerProtocol,
        recipeID: String
    ) {
        self.dependencyContainer = dependencyContainer
        self.recipeID = recipeID
        self.viewModel = RecipeDetailViewModel(
            apiService: dependencyContainer.apiService,
            coredataService: dependencyContainer.coredataService
        )
    }

    var body: some View {
        VStack {
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

                        heartButton
                        ratingView
                    }
                    .padding()
                }
            } else {
                Text("No data available.")
            }
        }
        .navigationTitle("Recipe Details")
        .onAppear {
            viewModel.fetchRecipeDetail(for: recipeID)
        }
        .onDisappear {
            viewModel.saveRecipeLocally()
        }
    }

    private var heartButton: some View {
            Button(action: {
                viewModel.toggleLike()
            }) {
                Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                    .foregroundColor(viewModel.isLiked ? .red : .gray)
                    .font(.largeTitle)
            }
            .padding()
        }

    private var ratingView: some View {
        HStack {
            ForEach(1..<6) { star in
                Image(systemName: star <= viewModel.rating ? "star.fill" : "star")
                    .foregroundColor(star <= viewModel.rating ? .yellow : .gray)
                    .onTapGesture {
                        viewModel.rating = Int(star)
                    }
            }
        }
        .padding()
    }
}
