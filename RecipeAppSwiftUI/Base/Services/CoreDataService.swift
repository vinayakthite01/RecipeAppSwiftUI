//
//  CoreDataService.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 10/12/24.
//

import CoreData
import Combine
import UIKit

// MARK: - CoreDataService
protocol CoreDataServiceProtocol {
    
    /// Get path for the database
    func whereIsMySQLite()
    
    /// Save Recipes in
    /// - Parameters:
    ///   - recipe: recipe
    ///   - rating: user's rating
    ///   - isFavorite: favorite flag (true/false)
    /// - Returns: Void/ Error
    func saveRecipe(_ recipe: RecipeDetail, rating: Int, isFavorite: Bool) -> Future<Void, Error>
    
    /// Fetch all Saved Recipes
    /// - Returns: recipe list
    func fetchSavedRecipes() -> Future<[Recipe], Error>
    
    /// Save user details
    /// - Parameter user: user details
    /// - Returns: Void/ Error
    func saveUser(_ user: User) -> Future<Void, Error>
    
    /// Validate if user is registered
    /// - Parameters:
    ///   - username: username
    ///   - password: password
    /// - Returns: User/ Error
    func validateUser(username: String, password: String) -> Future<User?, Error>
    
    /// Fetch User Details
    /// - Parameter username: for username
    /// - Returns: User/ Error
    func fetchUserDetails(username: String) -> Future<User?, Error>
}

// MARK: - CoreData Service
class CoreDataService: CoreDataServiceProtocol {
    static let shared = CoreDataService()
    
    private init() {}
    
    /// Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    /// Context reference
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func whereIsMySQLite() {
        let path = NSPersistentContainer
            .defaultDirectoryURL()
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding

        #if DEBUG
            print("Database Path: \(path ?? "Not found")")
        #endif
    }

    /// Save Context
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func saveRecipe(_ recipe: RecipeDetail, rating: Int, isFavorite: Bool) -> Future<Void, Error> {
        return Future { promise in
            let savedRecipe = SavedRecipe(context: self.context)
            savedRecipe.id = recipe.idMeal
            savedRecipe.name = recipe.strMeal
            savedRecipe.image = recipe.strMealThumb
            savedRecipe.isFavorite = recipe.isFavorite ?? false
            savedRecipe.rating = Int64(rating)
            
            self.saveContext()
            promise(.success(()))
        }
    }
    
    func fetchSavedRecipes() -> Future<[Recipe], Error> {
        return Future { promise in
            let fetchRequest: NSFetchRequest<SavedRecipe> = SavedRecipe.fetchRequest()
            
            do {
                let savedRecipes = try self.context.fetch(fetchRequest)
                let recipes = savedRecipes.map { Recipe(idMeal: $0.id ?? "", strMeal: $0.name ?? "", strMealThumb: $0.image ?? "") }
                promise(.success(recipes))
            } catch {
                promise(.failure(error))
            }
        }
    }
    
    func saveUser(_ user: User) -> Future<Void, Error> {
        return Future { promise in
            let userEntity = UserEntity(context: self.context)
            userEntity.id = user.id
            userEntity.username = user.username
            userEntity.password = user.password
            userEntity.profileImage = user.profileImage
            
            self.saveContext()
            promise(.success(()))
        }
    }
    
    func validateUser(username: String, password: String) -> Future<User?, Error> {
        return Future { promise in
            let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)
            do {
                let userEntities = try self.context.fetch(fetchRequest)
                Logger.log("userEntities: \(userEntities)")
                if let userEntity = userEntities.first {
                    let user = User(
                        id: userEntity.id ?? UUID(),
                        username: userEntity.username ?? "",
                        password: userEntity.password ?? "",
                        profileImage: userEntity.profileImage ?? Data()
                    )
                    Logger.log("user: \(user)")
                    promise(.success(user))
                } else {
                    Logger.log("user returned as nil")
                    promise(.success(nil))
                }
            } catch {
                Logger.log("error: \(error.localizedDescription)")
                promise(.failure(error))
            }
        }
    }
    
    func fetchUserDetails(username: String) -> Future<User?, Error> {
        return Future { promise in
            let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "username == %@", username)
            do {
                let userEntities = try self.context.fetch(fetchRequest)
                Logger.log("userEntities: \(userEntities)")
                if let userEntity = userEntities.first {
                    let user = User(
                        id: userEntity.id ?? UUID(),
                        username: userEntity.username ?? "",
                        password: "",
                        profileImage: userEntity.profileImage ?? Data()
                    )
                    Logger.log("user: \(user)")
                    promise(.success(user))
                } else {
                    Logger.log("user returned as nil")
                    promise(.success(nil))
                }
            } catch {
                Logger.log("error: \(error.localizedDescription)")
                promise(.failure(error))
            }
        }
    }
}
