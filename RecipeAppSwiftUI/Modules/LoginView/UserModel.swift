//
//  UserModel.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 10/12/24.
//

import Foundation
import CoreData

struct User: Codable {
    let id: UUID
    let username: String
    let password: String
    let profileImage: Data?
}
