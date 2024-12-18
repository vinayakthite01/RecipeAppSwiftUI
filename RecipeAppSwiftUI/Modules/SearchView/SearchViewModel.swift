//
//  SearchViewModel.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 17/12/24.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var recipes: [RecipeDetail]? = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
        setupSearchBinding()
    }

    private func setupSearchBinding() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.searchRecipes(query: searchText)
            }
            .store(in: &cancellables)
    }

    private func searchRecipes(query: String) {
        guard !query.isEmpty else {
            recipes = []
            return
        }
        
        isLoading = true
        errorMessage = nil

        apiService.searchRecipe(query: query)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.description
                }
            }, receiveValue: { [weak self] recipes in
                if recipes.isEmpty == true {
                    self?.errorMessage = "No data found"
                } else {
                    self?.recipes = recipes
                }
            })
            .store(in: &cancellables)
    }
}
