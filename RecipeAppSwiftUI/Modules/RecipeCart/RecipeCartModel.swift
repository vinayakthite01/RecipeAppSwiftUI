//
//  RecipeCartModel.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 26/12/24.
//

import SwiftUI

struct CartItem: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    let quantity: Int
}
