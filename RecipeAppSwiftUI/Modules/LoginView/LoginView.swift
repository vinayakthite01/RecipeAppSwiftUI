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
                .frame(width: 350, height: 40, alignment: .center)
                .textFieldStyle(PlainTextFieldStyle())
                .padding([.leading, .trailing], 5)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray))
                .padding()
            
            SecureField("Password", text: $viewModel.password)
                .autocapitalization(.none)
                .frame(width: 350, height: 40, alignment: .center)
                .textFieldStyle(PlainTextFieldStyle())
                .padding([.leading, .trailing], 5)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray))
                .padding()
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage).foregroundColor(.red)
            }
            HStack {
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
                
                Spacer()
                    .frame(width: 40)
                
                Button(action: {
                    
                }
                       ) {
                    Text("Register")
                        .padding()
                        .frame(width: 140.0, height: 60.0)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .fullScreenCover(isPresented: $showMainTabView) {
            MainTabView(dependency: dependencyContainer)
        }
    }
}

#Preview {
    LoginView(dependencyContainer: DependencyContainer())
}
