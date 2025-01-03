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
    
    /// Save Recipes in Core data
    /// - Parameters:
    ///   - recipe: recipe
    ///   - rating: user's rating
    ///   - isFavorite: favourite flag (true/false)
    /// - Returns: Void/ Error
    func saveRecipe(_ recipe: RecipeDetail, rating: Int, isFavorite: Bool) -> Future<Void, Error>
    
    /// Fetch all Saved Recipes
    /// - Returns: recipe list
    func fetchAllSavedRecipes() -> Future<[Recipe], Error>
    
    /// Fetch RecipeDetails from Core data
    /// - Parameter id: recipe id
    /// - Returns: recipe detail
    func fetchRecipeDetails(id: String) -> Future<RecipeDetail?, Error>
    
    /// Register user details
    /// - Parameter user: user details
    /// - Returns: Void/ Error
    func registerUser(_ user: User) -> AnyPublisher<Bool, APIError>
    
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
            var recipeDetail: SavedRecipe!
            let fetchRequest: NSFetchRequest<SavedRecipe> = SavedRecipe.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", recipe.id)
            
            do {
                let savedRecipes = try self.context.fetch(fetchRequest)
                
                if savedRecipes.count == 0 {
                    // insert recipe
                    recipeDetail = SavedRecipe(context: self.context)
                } else {
                    // update recipe
                    recipeDetail = savedRecipes.first
                }
            } catch {
                promise(.failure(error))
            }
            
            recipeDetail?.id = recipe.idMeal
            recipeDetail?.name = recipe.strMeal
            recipeDetail?.image = recipe.strMealThumb
            recipeDetail?.isFavorite = isFavorite
            recipeDetail?.rating = Int64(rating)
            
            self.saveContext()
            promise(.success(()))
        }
    }
    
    func fetchAllSavedRecipes() -> Future<[Recipe], Error> {
        return Future { promise in
            let fetchRequest: NSFetchRequest<SavedRecipe> = SavedRecipe.fetchRequest()
            
            do {
                let savedRecipes = try self.context.fetch(fetchRequest)
                let recipes = savedRecipes.map {
                    Recipe(
                        idMeal: $0.id ?? "",
                        strMeal: $0.name ?? "",
                        strMealThumb: $0.image ?? ""
                    )
                }
                promise(.success(recipes))
            } catch {
                promise(.failure(error))
            }
        }
    }
    
    func checkRecipeExists(id: String) -> Future<Bool, Error> {
        return Future { promise in
            let fetchRequest: NSFetchRequest<SavedRecipe> = SavedRecipe.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            
            do {
                let savedRecipes = try self.context.fetch(fetchRequest)
                savedRecipes.count > 0 ? promise(.success(true)) : promise(.success(false))
            } catch {
                promise(.failure(error))
            }
        }
    }
    
    func registerUser(_ user: User) -> AnyPublisher<Bool, APIError> {
        return checkUserAlreadyExists(username: user.username)
            .flatMap { userExists -> Future<Void, APIError> in
                if userExists {
                    return Future {
                        // If user exists, return an empty failure
                        Logger.log("user already exists!")
                        $0(.failure(APIError.userAlreadyExists))
                    }
                } else {
                    return self.saveUser(user)
                }
            }
            .map { _ in
                // Map the result to true to indicate the process was successful
                Logger.log("user Saved Successfully!")
                return true
            }
            .eraseToAnyPublisher()
    }
    
    func saveUser(_ user: User) -> Future<Void, APIError> {
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
    
    func checkUserAlreadyExists(username: String) -> Future<Bool, APIError> {
        return Future { promise in
            let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "username == %@", username)
            do {
                let userEntities = try self.context.fetch(fetchRequest)
                userEntities.count > 0 ? promise(.success(true)) : promise(.success(false))
            } catch {
                Logger.log("error: \(error.localizedDescription)")
                promise(.failure(.somethingWentWrong))
            }
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
    
    func fetchRecipeDetails(id: String) -> Future<RecipeDetail?, Error> {
        return Future { promise in
            let fetchRequest: NSFetchRequest<SavedRecipe> = SavedRecipe.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            
            do {
                let recipeDetailEntities = try self.context.fetch(fetchRequest)
                if let recipeDetailEntity = recipeDetailEntities.first {
                    let recipeDetail = RecipeDetail(
                        idMeal: recipeDetailEntity.id ?? UUID().uuidString,
                        strMeal: recipeDetailEntity.name ?? "",
                        strCategory: "",
                        strArea: "",
                        strInstructions: "",
                        strMealThumb: recipeDetailEntity.image ?? "",
                        strTags: "",
                        strYoutube: "",
                        isFavorite: recipeDetailEntity.isFavorite,
                        rating: Int(recipeDetailEntity.rating)
                    )
                    promise(.success(recipeDetail))
                } else {
                    Logger.log("No recipe detail found in Core Data for id: \(id)")
                    promise(.success(nil))
                }
            } catch {
                Logger.log("Error fetching recipe detail from Core Data: \(error)")
                promise(.failure(error))
            }
        }
    }
}
