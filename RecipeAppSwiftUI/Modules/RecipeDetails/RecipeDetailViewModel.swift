//
//  RecipeDetailViewModel.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 04/12/24.
//

import Foundation
import Combine

// MARK: - Recipe Detail ViewModel
class RecipeDetailViewModel: ObservableObject {
    // MARK: - Properties    
    @Published var recipeDetail: RecipeDetail?
    @Published var coreDataRecipe: RecipeDetail?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isLiked = false
    @Published var rating = 0

    private var cancellables = Set<AnyCancellable>()
    private let recipeDetailSubject = PassthroughSubject<RecipeDetail?, Never>()
    private let apiService: APIServiceProtocol
    private let coredataService: CoreDataServiceProtocol
    
    init(apiService: APIServiceProtocol, coredataService: CoreDataServiceProtocol) {
        self.apiService = apiService
        self.coredataService = coredataService
    }

    // MARK: - Functions
    
    /// Fetch Recipes details from APIs
    /// - Parameter id: id of the recipe
    func fetchRecipeDetail(for id: String) {
        isLoading = true
        errorMessage = nil
        
        let apiPublisher = apiService.fetchRecipe(recipeId: id)
            .map { $0.first }
            .catch { _ in Just(nil) }
            .eraseToAnyPublisher()
        
        let coreDataPublisher = fetchRecipeDetailsFromCoreData(recipeId: id)
            .handleEvents(receiveOutput: { _ in
                Logger.log("Received Core Data output")
            }, receiveCompletion: { completion in
                Logger.log("Core Data publisher completed: \(completion)")
            })
            .eraseToAnyPublisher()
        
        Publishers.CombineLatest(apiPublisher, coreDataPublisher)
            .map { (apiResult, coreDataResult) -> RecipeDetail? in
                if let coreDataDetail = coreDataResult, let apiDetail = apiResult {
                    return self.mergeRecipeDetails(apiDetail: apiDetail, coreDataDetail: coreDataDetail)
                } else if let apiResult = apiResult {
                    return apiResult
                } else {
                    return coreDataResult
                }
            }
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] mergedDetail in
                self?.isLoading = false
                guard let mergedDetail else { return }
                self?.recipeDetail = mergedDetail
                self?.isLiked = mergedDetail.isFavorite ?? false
                self?.rating = mergedDetail.rating ?? 0
            }
            .store(in: &cancellables)
    }
    
    /// Fetch Recipe from core data for the given id
    /// - Parameter recipeId: recipe id
    private func fetchRecipeDetailsFromCoreData(recipeId: String) -> AnyPublisher<RecipeDetail?, Never> {
        return coredataService.fetchRecipeDetails(id: recipeId)
            .map { recipeDetail in
                Logger.log("recipeDetail from coredata: \(recipeDetail)")
                return recipeDetail
            }
            .catch { [weak self] error -> Just<RecipeDetail?> in
                self?.errorMessage = error.localizedDescription
                Logger.log("Error: \(error)")
                return Just<RecipeDetail?>(nil)
            }
            .eraseToAnyPublisher()
    }
    
    /// Merge recipe detail results from api and core data
    /// - Parameters:
    ///   - apiDetail: recipe details from api
    ///   - coreDataDetail: recipe details from core data
    private func mergeRecipeDetails(apiDetail: RecipeDetail, coreDataDetail: RecipeDetail) -> RecipeDetail {
        return RecipeDetail(
            idMeal: apiDetail.idMeal,
            strMeal: coreDataDetail.strMeal.isEmpty ? apiDetail.strMeal : coreDataDetail.strMeal,
            strCategory: apiDetail.strCategory,
            strArea: apiDetail.strArea,
            strInstructions: apiDetail.strInstructions,
            strMealThumb: apiDetail.strMealThumb,
            strTags: apiDetail.strTags,
            strYoutube: apiDetail.strYoutube,
            isFavorite: coreDataDetail.isFavorite,
            rating: coreDataDetail.rating
        )
    }
    
    /// Save recipe as favourite
    func saveRecipeLocally() {
        guard let recipeDetail = self.recipeDetail else {
            Logger.log("Error: No recipe detail to save")
            return
        }
        coredataService.saveRecipe(recipeDetail, rating: rating, isFavorite: isLiked)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case.failure(let error):
                    self?.errorMessage = error.localizedDescription
                case.finished:
                    break
                }
            } receiveValue: { _ in
                Logger.log("recipe saved successfully")
            }
            .store(in: &cancellables)
    }
    
    /// Toggle with favourite button
    func toggleLike() {
        isLiked.toggle()
        Logger.log("isLiked: \(isLiked)")
    }
}
