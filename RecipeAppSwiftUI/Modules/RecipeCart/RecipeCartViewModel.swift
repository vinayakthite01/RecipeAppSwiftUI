//
//  RecipeCartViewModel.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 26/12/24.
//

import SwiftUI
import Combine

class CartViewModel: ObservableObject {
    @Published var cartItems: [CartItem] = [
        CartItem(name: "Apple", price: 1.99, quantity: 2),
        CartItem(name: "Banana", price: 0.99, quantity: 5),
        CartItem(name: "Orange", price: 2.49, quantity: 3)
    ]
    
    var totalPrice: Double {
        cartItems.reduce(0) { $0 + $1.price * Double($1.quantity) }
    }
    
    func checkout() {
        // Handle checkout logic here
        print("Proceeding to checkout with total price: \(totalPrice)")
    }
}
