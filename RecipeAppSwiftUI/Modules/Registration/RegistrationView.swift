//
//  Registration.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 16/12/24.
//

import SwiftUI

struct RegistrationView: View {
    let dependencyContainer: DependencyContainerProtocol
    @ObservedObject private var viewModel: RegistrationViewModel
    @State private var showMainTabView: Bool = false
    
    init(dependencyContainer: DependencyContainerProtocol) {
        self.dependencyContainer = dependencyContainer
        viewModel = RegistrationViewModel(coredataService: dependencyContainer.coredataService)
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
                viewModel.register()
            }) {
                Text("Register")
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
