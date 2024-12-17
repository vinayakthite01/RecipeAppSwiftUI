//
//  RegistrationViewModel.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 16/12/24.
//

import Foundation
import CoreData

class RegistrationViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let coreDataService: CoreDataServiceProtocol
    
    init(coredataService: CoreDataServiceProtocol) {
        self.coreDataService = coredataService
    }
    
    func register() {
        isLoading = true
        coreDataService.saveUser(User(id: UUID(), username: username, password: password, profileImage: nil))
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case.failure(let error):
                    self?.errorMessage = error.localizedDescription
                case.finished:
                    break
                }
            } receiveValue: { _ in
                Logger.log("User registered successfully")
            }
    }
}
