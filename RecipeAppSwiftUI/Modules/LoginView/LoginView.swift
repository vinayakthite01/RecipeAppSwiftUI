//
//  LoginView.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 12/12/24.
//

import SwiftUI
import CoreData

struct LoginView: View {
    let dependencyContainer: DependencyContainerProtocol
    @ObservedObject private var viewModel: LoginViewModel
    @State private var showMainTabView: Bool = false
    
    init(dependencyContainer: DependencyContainerProtocol) {
        self.dependencyContainer = dependencyContainer
        viewModel = LoginViewModel(coredataService: dependencyContainer.coredataService)
    }
    
    var body: some View {
        VStack {
            TextField("Username", text: $viewModel.username)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $viewModel.password)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage).foregroundColor(.red)
            }
            
            Button(action: {
                viewModel.login()
                if viewModel.isAuthenticated {
                    showMainTabView = true
                }
            }) {
                Text("Login")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .fullScreenCover(isPresented: $showMainTabView) {
            MainTabView(dependency: dependencyContainer)
        }
    }
}
