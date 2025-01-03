//
//  RecipeCartView.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 26/12/24.
//

import SwiftUI

struct CartView: View {
    let dependencyContainer: DependencyContainerProtocol
    @ObservedObject var viewModel: CartViewModel
    
    init(
        dependencyContainer: DependencyContainerProtocol
    ) {
        self.dependencyContainer = dependencyContainer
        self.viewModel = CartViewModel()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.cartItems) { item in
                    HStack {
                        Text(item.name)
                            .font(.headline)
                        Spacer()
                        Text("\(item.quantity) x $\(item.price, specifier: "%.2f")")
                            .font(.subheadline)
                    }
                }
                .listStyle(PlainListStyle())
                
                HStack {
                    Text("Total:")
                        .font(.headline)
                    Spacer()
                    Text("$\(viewModel.totalPrice, specifier: "%.2f")")
                        .font(.headline)
                }
                .padding()
                
                Button(action: {
                    viewModel.checkout()
                }) {
                    Text("Checkout")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Cart")
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(dependencyContainer: DependencyContainer())
    }
}
