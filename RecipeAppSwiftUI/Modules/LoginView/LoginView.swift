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
    @State private var navigationPath = NavigationPath()
    
    init(dependencyContainer: DependencyContainerProtocol) {
        self.dependencyContainer = dependencyContainer
        viewModel = LoginViewModel(coredataService: dependencyContainer.coredataService)
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                TextField("Username", text: $viewModel.username)
                    .autocapitalization(.none)
                    .frame(width: 350, height: 50, alignment: .center)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.leading, .trailing], 5)
                    .overlay(Rectangle().stroke(Color.gray))
                    .padding()
                
                SecureField("Password", text: $viewModel.password)
                    .autocapitalization(.none)
                    .frame(width: 350, height: 50, alignment: .center)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.leading, .trailing], 5)
                    .overlay(Rectangle().stroke(Color.gray))
                    .padding()
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage).foregroundColor(.red)
                        .padding()
                }
                
                Button(action: {
                    viewModel.login()
                    if viewModel.isAuthenticated {
                        showMainTabView = true
                    }
                }) {
                    Text("Login")
                        .padding()
                        .frame(width: 140.0, height: 60.0)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding([.top, .bottom])
                
                Button(action: {
                    navigationPath.append("RegistrationView")
                }) {
                    Text("Don't have account?\nSign up")
                        .padding()
                        .frame(height: 120.0)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
            }
            .padding()
            .fullScreenCover(isPresented: $showMainTabView) {
                MainTabView(dependency: dependencyContainer)
            }
            .navigationTitle("Login")
            .navigationDestination(for: String.self) { value in
                if value == "RegistrationView" {
                    RegistrationView(dependencyContainer: dependencyContainer)
                }
            }
        }
    }
}

#Preview {
    LoginView(dependencyContainer: DependencyContainer())
}
