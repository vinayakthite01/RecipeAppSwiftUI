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
    var apiService: APIServiceProtocol { get }
    var coredataService: CoreDataServiceProtocol { get }
}

// MARK: Confirming to Resource Protocol

/// Dependency Container to initialise all the dependencies at once
struct DependencyContainer: DependencyContainerProtocol {
    var apiService: APIServiceProtocol
    var coredataService: CoreDataServiceProtocol
    
    /// Takes all the dependencies object for self initialization
    init() {
        self.apiService = APIService()
        self.coredataService = CoreDataService.shared
        coredataService.whereIsMySQLite()
    }
}
