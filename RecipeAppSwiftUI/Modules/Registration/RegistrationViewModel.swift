//
//  RegistrationViewModel.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 16/12/24.
//

import Foundation
import CoreData
import Combine

class RegistrationViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var successMessage: String?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let coreDataService: CoreDataServiceProtocol
    
    init(coredataService: CoreDataServiceProtocol) {
        self.coreDataService = coredataService
    }
    
    func register() {
        isLoading = true
        let user = User(id: UUID(), username: username, password: password, profileImage: nil)
        coreDataService.registerUser(user)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case.failure(let error):
                    self?.successMessage = nil
                    self?.errorMessage = error.description
                case.finished:
                    break
                }
            } receiveValue: { [weak self] _ in
                self?.successMessage = "User registered successfully"
                self?.errorMessage = nil
            }
            .store(in: &cancellables)
    }
    
    func validate() -> Bool {
        errorMessage = nil
        if username.count <= 4 && password.count <= 4 {
            successMessage = nil
            errorMessage = "Username and password must be at least 4 characters long"
            return false
        } else if username.count < 4 {
            successMessage = nil
            errorMessage = "Username must be at least 4 characters long"
            return false
        } else if password.count < 4 {
            successMessage = nil
            errorMessage = "Password must be at least 4 characters long"
            return false
        } else {
            successMessage = nil
            errorMessage = nil
            return true
        }
    }
}
