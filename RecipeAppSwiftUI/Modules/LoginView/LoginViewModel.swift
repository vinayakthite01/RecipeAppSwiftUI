//
//  LoginViewModel.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 10/12/24.
//

import Foundation
import CoreData

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    
    private let coreDataService: CoreDataServiceProtocol
    
    init(coredataService: CoreDataServiceProtocol) {
        self.coreDataService = coredataService
    }
    
    func login() {
        isLoading = true
        coreDataService.validateUser(username: username, password: password)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case.failure(let error):
                    self?.errorMessage = error.localizedDescription
                case.finished:
                    Logger.log("Finished fetching the user")
                    break
                }
            } receiveValue: { [weak self] user in
                guard let userName = user?.username else {
                    Logger.log("user not found!")
                    self?.errorMessage = "User not found!"
                    self?.isAuthenticated = false
                    return
                }
                self?.username = userName
                UserDefaults.standard.set(userName, forKey: "loggedinUser")
                Logger.log("userName: \(userName)")
                self?.isAuthenticated = true
            }
    }
}
