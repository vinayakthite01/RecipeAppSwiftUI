//
//  ViewModels.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 03/12/24.
//

import Foundation
import Combine

class CategoriesViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let apiService = APIService()

    func fetchCategories() {
        isLoading = true
        errorMessage = nil
        
        apiService.fetchAllCategories()
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let apiError):
                    self?.errorMessage = apiError.localizedDescription
                }
            } receiveValue: { [weak self] response in
                Logger.log("Response: \(response)")
//                self?.categories = response
            }
            .store(in: &cancellables)
    }
}
