//
//  DependencyManager.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 10/12/24.
//

import Foundation
// MARK: DependencyContainerProtocol
/*
 Protocol to force store required services, dependencies or other resources
 Works as dependencies container
 */
protocol DependencyContainerProtocol {
    /// API Manager
    var apiManager: APIServiceProtocol { get }
}

// MARK: Confirming to Resource Protocol
struct DependencyContainer: DependencyContainerProtocol {
    var apiManager: APIServiceProtocol
    
    /// Takes all the dependencies object for self initialization
    /// - Parameter apiManager: apiManager
    init(apiManager: APIServiceProtocol) {
        self.apiManager = apiManager
    }
}
