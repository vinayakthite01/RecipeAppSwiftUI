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
    func whereIsMySQLite()
    func saveFavoriteRecipe(_ recipe: Recipe) -> Future<Void, Error>
    func fetchFavoriteRecipes() -> Future<[Recipe], Error>
    func saveUser(_ user: User) -> Future<Void, Error>
    func fetchUser(username: String, password: String) -> Future<User?, Error>
}

// MARK: - CoreData Service
class CoreDataService: CoreDataServiceProtocol {
    static let shared = CoreDataService()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
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
    
    /// Save Favorite Recipe
    /// - Parameter recipe: recipe model
    /// - Returns: completion
    func saveFavoriteRecipe(_ recipe: Recipe) -> Future<Void, Error> {
        return Future { promise in
            let favoriteRecipe = FavoriteRecipe(context: self.context)
            favoriteRecipe.id = recipe.idMeal
            favoriteRecipe.name = recipe.strMeal
            favoriteRecipe.image = recipe.strMealThumb
            
            self.saveContext()
            promise(.success(()))
        }
    }
    
    /// Fetch Favorite Recipe
    /// - Returns: Future Recipe
    func fetchFavoriteRecipes() -> Future<[Recipe], Error> {
        return Future { promise in
            let fetchRequest: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
            
            do {
                let favoriteRecipes = try self.context.fetch(fetchRequest)
                let recipes = favoriteRecipes.map { Recipe(idMeal: $0.id ?? "", strMeal: $0.name ?? "", strMealThumb: $0.image ?? "") }
                promise(.success(recipes))
            } catch {
                promise(.failure(error))
            }
        }
    }
    
    /// Save user Details
    /// - Parameter user: User Description
    /// - Returns: completion
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
    
    /// Fetch User Details
    /// - Parameter username: username
    /// - Parameter password: password
    /// - Returns: Future user
    func fetchUser(username: String, password: String) -> Future<User?, Error> {
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
}
