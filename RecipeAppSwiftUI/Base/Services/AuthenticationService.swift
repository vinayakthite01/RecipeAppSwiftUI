//
//  AuthenticationService.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 20/12/24.
//

import Combine
import Foundation

protocol AuthenticationServiceProtocol: ObservableObject {
    func checkIfLoggedIn()
    func logIn()
    func logOut()
}

class AuthenticationService: AuthenticationServiceProtocol {
    @Published var isLoggedIn: Bool = false
    
    // This method should be replaced with the actual logic to check if the user is logged in
    func checkIfLoggedIn() {
        // Example logic to check login status
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "loggedinUser")
    }
    
    // This method can be used to log in the user
    func logIn() {
        self.isLoggedIn = true
        UserDefaults.standard.set(true, forKey: "loggedinUser")
    }
    
    // This method can be used to log out the user
    func logOut() {
        self.isLoggedIn = false
        UserDefaults.standard.set(false, forKey: "loggedinUser")
    }
}
